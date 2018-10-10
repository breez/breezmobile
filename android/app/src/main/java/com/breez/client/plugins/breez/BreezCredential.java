package com.breez.client.plugins.breez;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import android.app.KeyguardManager;

import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyPermanentlyInvalidatedException;
import android.security.keystore.KeyProperties;
import android.security.keystore.UserNotAuthenticatedException;

import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;

import static android.app.Activity.RESULT_OK;

public class BreezCredential implements MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {
    public static final String BREEZ_CREDENTIAL_CHANNEL_NAME = "com.breez.client/credential";
    private final Activity m_activity;
    private MethodChannel m_methodChannel;
    private MethodChannel.Result m_result;

    private static final String KEY_NAME = "breez_key";

    // TODO: Change the byte array to something more secretive
    private static final byte[] SECRET_BYTE_ARRAY = new byte[] {1, 2, 3, 4, 5, 6};

    private static final int REQUEST_CODE_CONFIRM_DEVICE_CREDENTIALS = 74;
    private static final int AUTHENTICATION_DURATION_SECONDS = 30;

    private KeyguardManager m_keyguardManager;

    public BreezCredential(PluginRegistry.Registrar registrar, Activity activity) {
        this.m_activity = activity;
        m_methodChannel = new MethodChannel(registrar.messenger(), BREEZ_CREDENTIAL_CHANNEL_NAME);
        m_methodChannel.setMethodCallHandler(this);

        registrar.addActivityResultListener(this);

        m_keyguardManager = (KeyguardManager) m_activity.getSystemService(Context.KEYGUARD_SERVICE);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_CONFIRM_DEVICE_CREDENTIALS) {
            // Challenge completed, proceed with using cipher
            if (resultCode == RESULT_OK) {
                try {
                    tryEncrypt();
                }
                catch (RuntimeException e) {
                    m_result.error("TRY_ENCRYPT_FAILED", e.getMessage(), e);
                }
            } else {
                m_result.error("AUTH_FAILED", "Authentification failed", true);
            }
            return true;
        }
        return false;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (!m_keyguardManager.isKeyguardSecure()) {
            // User has no lock set up. Perhaps block him from doing anything?
            result.error("KEYGUARD_NOT_SECURE", "No lockscreen set up", true);
        }

        if (call.method.equals("confirm")) {
            m_result = result;
            try {
                tryEncrypt();
            }
            catch (RuntimeException e) {
                result.error("TRY_ENCRYPT_FAILED", e.getMessage(), e);
            }
        }
        else if (call.method.equals("createKey")) {
            try {
                createKey();
                result.success(true);
            }
            catch (RuntimeException e) {
                result.error("CREATE_KEY_FAILED", e.getMessage(), e);
            }
        }
    }

    private void tryEncrypt() {
        try {
            KeyStore keyStore = KeyStore.getInstance("AndroidKeyStore");
            keyStore.load(null);
            SecretKey secretKey = (SecretKey) keyStore.getKey(KEY_NAME, null);
            Cipher cipher = Cipher.getInstance(
                    KeyProperties.KEY_ALGORITHM_AES + "/" + KeyProperties.BLOCK_MODE_CBC + "/"
                            + KeyProperties.ENCRYPTION_PADDING_PKCS7);

            // Encryption will only work if the user authenticated within the last AUTHENTICATION_DURATION_SECONDS seconds.
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            cipher.doFinal(SECRET_BYTE_ARRAY);

            // If the user has recently authenticated, you will reach here.
            m_result.success(true);
        } catch (UserNotAuthenticatedException e) {
            // User is not authenticated, let's authenticate with device credentials.
            showAuthenticationScreen();
        } catch (KeyPermanentlyInvalidatedException e) {
            // This happens if the lock screen has been disabled or reset after the key was
            // generated after the key was generated.
            m_result.success(false);
        } catch (BadPaddingException | IllegalBlockSizeException | KeyStoreException |
                CertificateException | UnrecoverableKeyException | IOException
                | NoSuchPaddingException | NoSuchAlgorithmException | InvalidKeyException e) {
            throw new RuntimeException(e);
        }
    }

    private void createKey() {
        try {
            KeyStore keyStore = KeyStore.getInstance("AndroidKeyStore");
            keyStore.load(null);
            KeyGenerator keyGenerator = KeyGenerator.getInstance(
                    KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");

            // Set the alias of the entry in Android KeyStore where the key will appear
            // and the constrains (purposes) in the constructor of the Builder
            keyGenerator.init(new KeyGenParameterSpec.Builder(KEY_NAME,
                    KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
                    .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
                    .setUserAuthenticationRequired(true)
                    // Require that the user has unlocked in the last 30 seconds
                    .setUserAuthenticationValidityDurationSeconds(AUTHENTICATION_DURATION_SECONDS)
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
                    .build());
            keyGenerator.generateKey();
        } catch (NoSuchAlgorithmException | NoSuchProviderException
                | InvalidAlgorithmParameterException | KeyStoreException
                | CertificateException | IOException e) {
            throw new RuntimeException("Failed to create a symmetric key", e);
        }
    }

    private void showAuthenticationScreen() {
        Intent intent = m_keyguardManager.createConfirmDeviceCredentialIntent("Please authenticate", "Breez needs to make sure you are you");
        if (intent != null) {
            m_activity.startActivityForResult(intent, REQUEST_CODE_CONFIRM_DEVICE_CREDENTIALS);
        }
    }
}
