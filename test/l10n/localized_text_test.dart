import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_es.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pt.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_sv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final locales = [
    AppLocalizationsEn(),
    AppLocalizationsEs(),
    AppLocalizationsFi(),
    AppLocalizationsFr(),
    AppLocalizationsIt(),
    AppLocalizationsPt(),
    AppLocalizationsSv(),
  ];

  // a unwarned translator can accidentaly change the placeholder key of a text
  // this test will fail if that happens
  group('placeholders should be present on texts', () {
    for (final locale in locales) {
      test('invoice_btc_address_warning_with_min_fee_account_connected for ${locale.locale}', () {
        final text = locale.invoice_btc_address_warning_with_min_fee_account_connected(
            minSats, maxSats, setUpFee, minFee, liquidity);
        expect(text.contains(minSats), true);
        expect(text.contains(maxSats), true);
        expect(text.contains(setUpFee), true);
        expect(text.contains(minFee), true);
        expect(text.contains(liquidity), true);
      });

      test('invoice_btc_address_warning_without_min_fee_account_connected for ${locale.locale}', () {
        final text =
            locale.invoice_btc_address_warning_without_min_fee_account_connected(minSats, maxSats, setUpFee, liquidity);
        expect(text.contains(minSats), true);
        expect(text.contains(maxSats), true);
        expect(text.contains(setUpFee), true);
        expect(text.contains(liquidity), true);
      });

      test('invoice_btc_address_warning_with_min_fee_account_not_connected for ${locale.locale}', () {
        final text =
            locale.invoice_btc_address_warning_with_min_fee_account_not_connected(minSats, maxSats, setUpFee, minFee);
        expect(text.contains(minSats), true);
        expect(text.contains(maxSats), true);
        expect(text.contains(setUpFee), true);
        expect(text.contains(minFee), true);
      });

      test('invoice_btc_address_warning_without_min_fee_account_not_connected for ${locale.locale}', () {
        final text =
            locale.invoice_btc_address_warning_without_min_fee_account_not_connected(minSats, maxSats, setUpFee);
        expect(text.contains(minSats), true);
        expect(text.contains(maxSats), true);
        expect(text.contains(setUpFee), true);
      });

      test('invoice_receive_fail_message for ${locale.locale}', () {
        final text = locale.invoice_receive_fail_message(reason);
        expect(text.contains(reason), true);
      });

      test('invoice_insufficient_amount_fee for ${locale.locale}', () {
        final text = locale.invoice_insufficient_amount_fee(fee);
        expect(text.contains(fee), true);
      });

      test('invoice_receive_label for ${locale.locale}', () {
        final text = locale.invoice_receive_label(maxSats);
        expect(text.contains(maxSats), true);
      });

      test('invoice_ln_address_warning_with_min_fee_account_connected for ${locale.locale}', () {
        final text = locale.invoice_ln_address_warning_with_min_fee_account_connected(setUpFee, minFee, liquidity);
        expect(text.contains(setUpFee), true);
        expect(text.contains(minFee), true);
        expect(text.contains(liquidity), true);
      });

      test('invoice_ln_address_warning_without_min_fee_account_connected for ${locale.locale}', () {
        final text = locale.invoice_ln_address_warning_without_min_fee_account_connected(setUpFee, liquidity);
        expect(text.contains(setUpFee), true);
        expect(text.contains(liquidity), true);
      });

      test('invoice_ln_address_warning_with_min_fee_account_not_connected for ${locale.locale}', () {
        final text = locale.invoice_ln_address_warning_with_min_fee_account_not_connected(setUpFee, minFee);
        expect(text.contains(setUpFee), true);
        expect(text.contains(minFee), true);
      });

      test('invoice_ln_address_warning_without_min_fee_account_not_connected for ${locale.locale}', () {
        final text = locale.invoice_ln_address_warning_without_min_fee_account_not_connected(setUpFee);
        expect(text.contains(setUpFee), true);
      });

      test('bottom_action_bar_warning_balance_title for ${locale.locale}', () {
        final text = locale.bottom_action_bar_warning_balance_title(balance);
        expect(text.contains(balance), true);
      });

      test('payment_details_dialog_closed_channel_about_hours for ${locale.locale}', () {
        final text = locale.payment_details_dialog_closed_channel_about_hours(hours);
        expect(text.contains(hours), true);
      });

      test('payment_details_dialog_closed_channel_transfer_estimation for ${locale.locale}', () {
        final text = locale.payment_details_dialog_closed_channel_transfer_estimation(lockHeightInt, hoursToUnlock);
        expect(text.contains(lockHeight), true);
        expect(text.contains(hoursToUnlock), true);
      });

      test('payment_details_dialog_copy_action for ${locale.locale}', () {
        final text = locale.payment_details_dialog_copy_action(title);
        expect(text.contains(title), true);
      });

      test('payment_details_dialog_copied for ${locale.locale}', () {
        final text = locale.payment_details_dialog_copied(title);
        expect(text.contains(title), true);
      });

      test('payment_details_dialog_amount_negative for ${locale.locale}', () {
        final text = locale.payment_details_dialog_amount_negative(amount);
        expect(text.contains(amount), true);
      });

      test('payment_details_dialog_amount_positive for ${locale.locale}', () {
        final text = locale.payment_details_dialog_amount_positive(amount);
        expect(text.contains(amount), true);
      });

      test('pos_invoice_charge_label for ${locale.locale}', () {
        final text = locale.pos_invoice_charge_label(amount, currencyName);
        expect(text.contains(amount), true);
        expect(text.contains(currencyName), true);
      });

      test('pos_invoice_error_capacity_message for ${locale.locale}', () {
        final text = locale.pos_invoice_error_capacity_message(maxAllowed);
        expect(text.contains(maxAllowed), true);
      });

      test('pos_invoice_error_payment_size_message for ${locale.locale}', () {
        final text = locale.pos_invoice_error_payment_size_message(maxAllowed);
        expect(text.contains(maxAllowed), true);
      });

      test('pos_transactions_item_positive for ${locale.locale}', () {
        final text = locale.pos_transactions_item_positive(value);
        expect(text.contains(value), true);
      });

      test('pos_transactions_item_negative for ${locale.locale}', () {
        final text = locale.pos_transactions_item_negative(value);
        expect(text.contains(value), true);
      });

      test('pos_transactions_item_fiat for ${locale.locale}', () {
        final text = locale.pos_transactions_item_fiat(fiat);
        expect(text.contains(fiat), true);
      });

      test('sale_view_total_title_read_only_no_fiat for ${locale.locale}', () {
        final text = locale.sale_view_total_title_read_only_no_fiat(value);
        expect(text.contains(value), true);
      });

      test('sale_view_total_title_charge_no_fiat for ${locale.locale}', () {
        final text = locale.sale_view_total_title_charge_no_fiat(value);
        expect(text.contains(value), true);
      });

      test('sale_view_total_title_read_only_fiat for ${locale.locale}', () {
        final text = locale.sale_view_total_title_read_only_fiat(value, fiatValue);
        expect(text.contains(value), true);
        expect(text.contains(fiatValue), true);
      });

      test('sale_view_total_title_charge_fiat for ${locale.locale}', () {
        final text = locale.sale_view_total_title_charge_fiat(value, fiatValue);
        expect(text.contains(value), true);
        expect(text.contains(fiatValue), true);
      });

      test('connect_to_pay_canceled_remote_user for ${locale.locale}', () {
        final text = locale.connect_to_pay_canceled_remote_user(name);
        expect(text.contains(name), true);
      });

      test('connect_to_pay_success_payer for ${locale.locale}', () {
        final text = locale.connect_to_pay_success_payer(name, amount);
        expect(text.contains(name), true);
        expect(text.contains(amount), true);
      });

      test('connect_to_pay_success_payee for ${locale.locale}', () {
        final text = locale.connect_to_pay_success_payee(name, amount);
        expect(text.contains(name), true);
        expect(text.contains(amount), true);
      });

      test('connect_to_pay_failed_to_connect for ${locale.locale}', () {
        final text = locale.connect_to_pay_failed_to_connect(error);
        expect(text.contains(error), true);
      });

      test('connect_to_pay_payee_success_received for ${locale.locale}', () {
        final text = locale.connect_to_pay_payee_success_received(amount);
        expect(text.contains(amount), true);
      });

      test('connect_to_pay_payee_waiting_with_name for ${locale.locale}', () {
        final text = locale.connect_to_pay_payee_waiting_with_name(name);
        expect(text.contains(name), true);
      });

      test('connect_to_pay_payee_message_no_fiat for ${locale.locale}', () {
        final text = locale.connect_to_pay_payee_message_no_fiat(name, amount);
        expect(text.contains(name), true);
        expect(text.contains(amount), true);
      });

      test('connect_to_pay_payee_message_with_fiat for ${locale.locale}', () {
        final text = locale.connect_to_pay_payee_message_with_fiat(name, amount, fiat);
        expect(text.contains(name), true);
        expect(text.contains(amount), true);
        expect(text.contains(fiat), true);
      });

      test('connect_to_pay_payee_error_limit_exceeds for ${locale.locale}', () {
        final text = locale.connect_to_pay_payee_error_limit_exceeds(amount);
        expect(text.contains(amount), true);
      });

      test('connect_to_pay_payee_process for ${locale.locale}', () {
        final text = locale.connect_to_pay_payee_process(name);
        expect(text.contains(name), true);
      });

      test('connect_to_pay_payee_setup_fee for ${locale.locale}', () {
        final text = locale.connect_to_pay_payee_setup_fee(sats, fiat);
        expect(text.contains(sats), true);
        expect(text.contains(fiat), true);
      });

      test('connect_to_pay_payer_success for ${locale.locale}', () {
        final text = locale.connect_to_pay_payer_success(amount);
        expect(text.contains(amount), true);
      });

      test('connect_to_pay_payer_enter_amount for ${locale.locale}', () {
        final text = locale.connect_to_pay_payer_enter_amount(name);
        expect(text.contains(name), true);
      });

      test('connect_to_pay_payer_waiting_join_with_name for ${locale.locale}', () {
        final text = locale.connect_to_pay_payer_waiting_join_with_name(name);
        expect(text.contains(name), true);
      });

      test('connect_to_pay_payer_waiting_approve_with_name for ${locale.locale}', () {
        final text = locale.connect_to_pay_payer_waiting_approve_with_name(name);
        expect(text.contains(name), true);
      });

      test('connect_to_pay_share_text for ${locale.locale}', () {
        final text = locale.connect_to_pay_share_text(name, address);
        expect(text.contains(name), true);
        expect(text.contains(address), true);
      });

      test('security_and_backup_last_backup_no_account for ${locale.locale}', () {
        final text = locale.security_and_backup_last_backup_no_account(lastBackup);
        expect(text.contains(lastBackup), true);
      });

      test('security_and_backup_last_backup_with_account for ${locale.locale}', () {
        final text = locale.security_and_backup_last_backup_with_account(lastBackup, accountName);
        expect(text.contains(lastBackup), true);
        expect(text.contains(accountName), true);
      });

      test('amount_form_denomination for ${locale.locale}', () {
        final text = locale.amount_form_denomination(denomination);
        expect(text.contains(denomination), true);
      });

      test('amount_form_insert_hint for ${locale.locale}', () {
        final text = locale.amount_form_insert_hint(denomination);
        expect(text.contains(denomination), true);
      });

      test('currency_converter_dialog_rate for ${locale.locale}', () {
        final text = locale.currency_converter_dialog_rate(rate, currencyName);
        expect(text.contains(rate), true);
        expect(text.contains(currencyName), true);
      });

      test('reverse_swap_confirmation_received_no_fiat for ${locale.locale}', () {
        final text = locale.reverse_swap_confirmation_received_no_fiat(received);
        expect(text.contains(received), true);
      });

      test('reverse_swap_confirmation_received_with_fiat for ${locale.locale}', () {
        final text = locale.reverse_swap_confirmation_received_with_fiat(received, fiat);
        expect(text.contains(received), true);
        expect(text.contains(fiat), true);
      });

      test('reverse_swap_confirmation_transaction_fee_value for ${locale.locale}', () {
        final text = locale.reverse_swap_confirmation_transaction_fee_value(fee);
        expect(text.contains(fee), true);
      });

      test('reverse_swap_confirmation_boltz_fee_value for ${locale.locale}', () {
        final text = locale.reverse_swap_confirmation_boltz_fee_value(fee);
        expect(text.contains(fee), true);
      });

      test('withdraw_funds_error_min_value for ${locale.locale}', () {
        final text = locale.withdraw_funds_error_min_value(minValue);
        expect(text.contains(minValue), true);
      });

      test('withdraw_funds_error_max_value for ${locale.locale}', () {
        final text = locale.withdraw_funds_error_max_value(maxValue);
        expect(text.contains(maxValue), true);
      });

      test('funds_over_limit_dialog_transfer_fail_with_reason for ${locale.locale}', () {
        final text = locale.funds_over_limit_dialog_transfer_fail_with_reason(reason);
        expect(text.contains(reason), true);
      });

      test('approximate_hours for ${locale.locale}', () {
        final text = locale.approximate_hours(hours);
        expect(text.contains(hours), true);
      });

      test('funds_over_limit_dialog_redeem_hours for ${locale.locale}', () {
        final text = locale.funds_over_limit_dialog_redeem_hours(lockHeight, hoursToUnlock);
        expect(text.contains(lockHeight), true);
        expect(text.contains(hoursToUnlock), true);
      });

      test('get_refund_amount for ${locale.locale}', () {
        final text = locale.get_refund_amount(amount);
        expect(text.contains(amount), true);
      });

      test('enter_backup_phrase for ${locale.locale}', () {
        final text = locale.enter_backup_phrase(number, total);
        expect(text.contains(number), true);
        expect(text.contains(total), true);
      });

      test('restore_dialog_multiple_accounts for ${locale.locale}', () {
        final text = locale.restore_dialog_multiple_accounts(name);
        expect(text.contains(name), true);
      });

      test('restore_dialog_modified_not_encrypted for ${locale.locale}', () {
        final text = locale.restore_dialog_modified_not_encrypted(date);
        expect(text.contains(date), true);
      });

      test('restore_dialog_modified_encrypted for ${locale.locale}', () {
        final text = locale.restore_dialog_modified_encrypted(date);
        expect(text.contains(date), true);
      });

      test('restore_dialog_download_backup_for_node for ${locale.locale}', () {
        final text = locale.restore_dialog_download_backup_for_node(nodeId);
        expect(text.contains(nodeId), true);
      });

      test('lsp_fee_warning_with_min_fee_account_connected for ${locale.locale}', () {
        final text = locale.lsp_fee_warning_with_min_fee_account_connected(setUpFee, minFee, liquidity);
        expect(text.contains(setUpFee), true);
        expect(text.contains(minFee), true);
        expect(text.contains(liquidity), true);
      });

      test('lsp_fee_warning_without_min_fee_account_connected for ${locale.locale}', () {
        final text = locale.lsp_fee_warning_without_min_fee_account_connected(setUpFee, liquidity);
        expect(text.contains(setUpFee), true);
        expect(text.contains(liquidity), true);
      });

      test('lsp_fee_warning_with_min_fee_account_not_connected for ${locale.locale}', () {
        final text = locale.lsp_fee_warning_with_min_fee_account_not_connected(setUpFee, minFee);
        expect(text.contains(setUpFee), true);
        expect(text.contains(minFee), true);
      });

      test('lsp_fee_warning_without_min_fee_account_not_connected for ${locale.locale}', () {
        final text = locale.lsp_fee_warning_without_min_fee_account_not_connected(setUpFee);
        expect(text.contains(setUpFee), true);
      });

      test('fee_chooser_estimated_delivery_hours for ${locale.locale}', () {
        final text = locale.fee_chooser_estimated_delivery_hours(hours);
        expect(text.contains(hours), true);
      });

      test('fee_chooser_estimated_delivery_hour_range for ${locale.locale}', () {
        final text = locale.fee_chooser_estimated_delivery_hour_range(hours);
        expect(text.contains(hours), true);
      });

      test('fee_chooser_estimated_delivery_minutes for ${locale.locale}', () {
        final text = locale.fee_chooser_estimated_delivery_minutes(minutes);
        expect(text.contains(minutes), true);
      });

      test('collapsible_list_action_copy for ${locale.locale}', () {
        final text = locale.collapsible_list_action_copy(title);
        expect(text.contains(title), true);
      });

      test('collapsible_list_copied for ${locale.locale}', () {
        final text = locale.collapsible_list_copied(title);
        expect(text.contains(title), true);
      });

      test('breez_date_picker_day_and_date for ${locale.locale}', () {
        final text = locale.breez_date_picker_day_and_date(day, date);
        expect(text.contains(day), true);
        expect(text.contains(date), true);
      });

      test('breez_date_picker_previous_month_tooltip for ${locale.locale}', () {
        final text = locale.breez_date_picker_previous_month_tooltip(message, date);
        expect(text.contains(message), true);
        expect(text.contains(date), true);
      });

      test('breez_date_picker_next_month_tooltip for ${locale.locale}', () {
        final text = locale.breez_date_picker_next_month_tooltip(message, date);
        expect(text.contains(message), true);
        expect(text.contains(date), true);
      });

      test('handler_lnurl_error_process for ${locale.locale}', () {
        final text = locale.handler_lnurl_error_process(message);
        expect(text.contains(message), true);
      });

      test('handler_lnurl_login_error_message for ${locale.locale}', () {
        final text = locale.handler_lnurl_login_error_message(message);
        expect(text.contains(message), true);
      });

      test('handler_lnurl_open_channel_message for ${locale.locale}', () {
        final text = locale.handler_lnurl_open_channel_message(host);
        expect(text.contains(host), true);
      });

      test('handler_lnurl_open_channel_error_message for ${locale.locale}', () {
        final text = locale.handler_lnurl_open_channel_error_message(message);
        expect(text.contains(message), true);
      });

      test('add_funds_item_voucher_message for ${locale.locale}', () {
        final text = locale.add_funds_item_voucher_message(value, currency);
        expect(text.contains(value), true);
        expect(text.contains(currency), true);
      });

      test('add_funds_item_exchange_rate_message for ${locale.locale}', () {
        final text = locale.add_funds_item_exchange_rate_message(rate, currency);
        expect(text.contains(rate), true);
        expect(text.contains(currency), true);
      });

      test('add_funds_item_commission_rate_message for ${locale.locale}', () {
        final text = locale.add_funds_item_commission_rate_message(rate);
        expect(text.contains(rate), true);
      });

      test('add_funds_item_commission_total_message for ${locale.locale}', () {
        final text = locale.add_funds_item_commission_total_message(commission, currency);
        expect(text.contains(commission), true);
        expect(text.contains(currency), true);
      });

      test('pos_custom_item_name for ${locale.locale}', () {
        final text = locale.pos_custom_item_name(indexInt);
        expect(text.contains(index), true);
      });

      test('pos_dialog_clock for ${locale.locale}', () {
        final text = locale.pos_dialog_clock(minutes, seconds);
        expect(text.contains(minutes), true);
        expect(text.contains(seconds), true);
      });

      test('pos_dialog_setup_fee for ${locale.locale}', () {
        final text = locale.pos_dialog_setup_fee(fee, fiat);
        expect(text.contains(fee), true);
        expect(text.contains(fiat), true);
      });

      test('pos_payment_nfc_range_error for ${locale.locale}', () {
        final text = locale.pos_payment_nfc_range_error(minValue, maxValue);
        expect(text.contains(minValue), true);
        expect(text.contains(maxValue), true);
      });

      test('catalog_item_error_delete for ${locale.locale}', () {
        final text = locale.catalog_item_error_delete(name);
        expect(text.contains(name), true);
      });

      test('lnurl_withdraw_dialog_error for ${locale.locale}', () {
        final text = locale.lnurl_withdraw_dialog_error(error);
        expect(text.contains(error), true);
      });

      test('qr_code_dialog_warning_message_with_lsp for ${locale.locale}', () {
        final text = locale.qr_code_dialog_warning_message_with_lsp(setUpFee, fiatFee);
        expect(text.contains(setUpFee), true);
        expect(text.contains(fiatFee), true);
      });

      test('qr_code_dialog_error for ${locale.locale}', () {
        final text = locale.qr_code_dialog_error(error);
        expect(text.contains(error), true);
      });

      test('waiting_broadcast_dialog_content_error for ${locale.locale}', () {
        final text = locale.waiting_broadcast_dialog_content_error(error);
        expect(text.contains(error), true);
      });

      test('wallet_dashboard_payment_item_balance_positive for ${locale.locale}', () {
        final text = locale.wallet_dashboard_payment_item_balance_positive(value);
        expect(text.contains(value), true);
      });

      test('wallet_dashboard_payment_item_balance_negative for ${locale.locale}', () {
        final text = locale.wallet_dashboard_payment_item_balance_negative(value);
        expect(text.contains(value), true);
      });

      test('wallet_dashboard_payment_item_balance_fee for ${locale.locale}', () {
        final text = locale.wallet_dashboard_payment_item_balance_fee(fee);
        expect(text.contains(fee), true);
      });

      test('qr_action_button_error_link_message for ${locale.locale}', () {
        final text = locale.qr_action_button_error_link_message(error);
        expect(text.contains(error), true);
      });

      test('lnurl_webview_error_message for ${locale.locale}', () {
        final text = locale.lnurl_webview_error_message(apiName);
        expect(text.contains(apiName), true);
      });

      test('lnurl_fetch_invoice_pay_to_payee for ${locale.locale}', () {
        final text = locale.lnurl_fetch_invoice_pay_to_payee(payee);
        expect(text.contains(payee), true);
      });

      test('lnurl_fetch_invoice_error_min for ${locale.locale}', () {
        final text = locale.lnurl_fetch_invoice_error_min(min);
        expect(text.contains(min), true);
      });

      test('lnurl_fetch_invoice_error_max for ${locale.locale}', () {
        final text = locale.lnurl_fetch_invoice_error_max(max);
        expect(text.contains(max), true);
      });

      test('lnurl_fetch_invoice_limit for ${locale.locale}', () {
        final text = locale.lnurl_fetch_invoice_limit(min, max);
        expect(text.contains(min), true);
        expect(text.contains(max), true);
      });

      test('lnurl_fetch_invoice_error_message for ${locale.locale}', () {
        final text = locale.lnurl_fetch_invoice_error_message(host, reason);
        expect(text.contains(host), true);
        expect(text.contains(reason), true);
      });

      test('podcast_boost_custom_amount_error_too_few for ${locale.locale}', () {
        final text = locale.podcast_boost_custom_amount_error_too_few(amountInt);
        expect(text.contains(amount), true);
      });

      test('podcast_boost_share_texts for ${locale.locale}', () {
        final text = locale.podcast_boost_share_texts(podcast, episode, link);
        expect(text.contains(podcast), true);
        expect(text.contains(episode), true);
        expect(text.contains(link), true);
      });

      test('podcast_boost_share_texts_short for ${locale.locale}', () {
        final text = locale.podcast_boost_share_texts_short(podcast, link);
        expect(text.contains(podcast), true);
        expect(text.contains(link), true);
      });

      test('podcast_speed_selector_speed for ${locale.locale}', () {
        final text = locale.podcast_speed_selector_speed(speed);
        expect(text.contains(speed), true);
      });

      test('backup_phrase_generation_index for ${locale.locale}', () {
        final text = locale.backup_phrase_generation_index(indexInt);
        expect(text.contains(index), true);
      });

      test('backup_phrase_generation_type_words for ${locale.locale}', () {
        final text = locale.backup_phrase_generation_type_words(numberAInt, numberBInt, numberCInt);
        expect(text.contains(numberA), true);
        expect(text.contains(numberB), true);
        expect(text.contains(numberC), true);
      });

      test('backup_phrase_generation_type_step for ${locale.locale}', () {
        final text = locale.backup_phrase_generation_type_step(numberInt);
        expect(text.contains(number), true);
      });

      test('spontaneous_payment_max_amount for ${locale.locale}', () {
        final text = locale.spontaneous_payment_max_amount(amount);
        expect(text.contains(amount), true);
      });

      test('spontaneous_payment_send_payment_message for ${locale.locale}', () {
        final text = locale.spontaneous_payment_send_payment_message(amount, nodeId);
        expect(text.contains(amount), true);
        expect(text.contains(nodeId), true);
      });

      test('sweep_all_coins_fee for ${locale.locale}', () {
        final text = locale.sweep_all_coins_fee(fee);
        expect(text.contains(fee), true);
      });

      test('sweep_all_coins_amount_no_fiat for ${locale.locale}', () {
        final text = locale.sweep_all_coins_amount_no_fiat(amount);
        expect(text.contains(amount), true);
      });

      test('sweep_all_coins_amount_with_fiat for ${locale.locale}', () {
        final text = locale.sweep_all_coins_amount_with_fiat(amount, fiat);
        expect(text.contains(amount), true);
        expect(text.contains(fiat), true);
      });

      test('close_warning_dialog_message_begin for ${locale.locale}', () {
        final text = locale.close_warning_dialog_message_begin(durationInt);
        expect(text.contains(duration), true);
      });

      test('payment_error_insufficient_balance_amount for ${locale.locale}', () {
        final text = locale.payment_error_insufficient_balance_amount(duration);
        expect(text.contains(duration), true);
      });

      test('status_failed_to_add_funds for ${locale.locale}', () {
        final text = locale.status_failed_to_add_funds(error);
        expect(text.contains(error), true);
      });

      test('valid_payment_error_exceeds_the_limit for ${locale.locale}', () {
        final text = locale.valid_payment_error_exceeds_the_limit(amount);
        expect(text.contains(amount), true);
      });

      test('valid_payment_error_keep_balance for ${locale.locale}', () {
        final text = locale.valid_payment_error_keep_balance(amount);
        expect(text.contains(amount), true);
      });

      test('payment_info_title_breez_sale for ${locale.locale}', () {
        final text = locale.payment_info_title_breez_sale(date);
        expect(text.contains(date), true);
      });

      test('payment_error_to_send for ${locale.locale}', () {
        final text = locale.payment_error_to_send(error);
        expect(text.contains(error), true);
      });
    }
  });
}

const accountName = "accountName";
const address = "address";
const amount = "34567";
const amountInt = 34567;
const apiName = "apiName";
const balance = "balance";
const commission = "commission";
const currency = "currency";
const currencyName = "currencyName";
const date = "date";
const day = "day";
const denomination = "denomination";
const duration = "3487";
const durationInt = 3487;
const episode = "episode";
const error = "error";
const fee = "fee";
const fiat = "fiat";
const fiatFee = "fiatFee";
const fiatValue = "fiatValue";
const host = "host";
const hours = "hours";
const hoursToUnlock = "hoursToUnlock";
const index = "67890";
const indexInt = 67890;
const lastBackup = "lastBackup";
const link = "link";
const liquidity = "liquidity";
const lockHeight = "12345";
const lockHeightInt = 12345;
const max = "max";
const maxAllowed = "maxAllowed";
const maxSats = "maxSats";
const maxValue = "maxValue";
const message = "message";
const min = "min";
const minFee = "minFee";
const minSats = "minSats";
const minutes = "minutes";
const minValue = "minValue";
const name = "name";
const nodeId = "nodeId";
const number = "7654";
const numberA = "99";
const numberAInt = 99;
const numberB = "88";
const numberBInt = 88;
const numberC = "77";
const numberCInt = 77;
const numberInt = 7654;
const payee = "payee";
const podcast = "podcast";
const rate = "rate";
const reason = "reason";
const received = "received";
const sats = "sats";
const seconds = "seconds";
const setUpFee = "setUpFee";
const speed = "speed";
const title = "title";
const total = "total";
const value = "value";
