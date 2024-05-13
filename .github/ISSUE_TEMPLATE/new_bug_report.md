name: Bug Report
description: Create a report to help us improve
labels: ["bug"]
assignees: []
body:
- type: textarea
  id: describe-the-bug
  attributes:
  label: Describe the bug
  description: A clear and concise description of what the bug is.
  validations:
  required: true
- type: textarea
  attributes:
  label: Steps to reproduce
  description: Write "non-reproducible" if the bug is non-reproducible.
  value: |
  Hint: A simple way to reproduce is to:
    1. Go to '...'
    2. Click on '....'
    3. Scroll down to '....'
    4. See ERROR
       validations:
       required: true
- type: textarea
  id: logs
  attributes:
  label: Logs
  description: Open Breez app, then go to `Preferences` > `Developers` and select `Share Logs` from the top right menu(`⋮`).
  placeholder: Open Breez app, then go to `Preferences` > `Developers` and select `Share Logs` from the top right menu(`⋮`).
  render: shell
  validations:
  required: false
  value: |
  # Please consider your privacy, before completing this section.
      Logs can be found at `Preferences` > `{} Developers` > 3 dots top right corner > `Share Logs`

- type: markdown
  id: screenshots
  attributes:
  label: Screenshots
  description: If applicable, add screenshots/video to help explain your problem.
  validations:
  required: false
  value: |
  # The following fields are *optional*
      If applicable, add screenshots/video to help explain your problem.

- type: markdown
  attributes:
  value: |
  # The following fields are *optional*
      ...but may be useful for debugging

- type: textarea
  id: expected-behavior
  attributes:
  label: Expected behavior
  description: A clear and concise description of what you expected to happen.
  validations:
  required: false

- type: markdown
  attributes:
  value: |
  What type of machine are you observing the error on?

- type: input
  id: env-os
  attributes:
  label: Operating System
  placeholder: ex. iOS 16.5/Android 13
  validations:
  required: false

- type: input
  id: env-version
  attributes:
  label: `Breez` Version
  placeholder: Which Breez release are you using? Where did you download it from?
  validations:
  required: false

- type: textarea
  id: additional-context
  attributes:
  label: Additional context
  description: Add any other context about the problem here.