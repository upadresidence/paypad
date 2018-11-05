class SandboxMaymayaCredential {
  static List<Map<String, dynamic>> list_cards = new List()
    ..add({
      'card_type': 'MASTERCARD',
      'number': '5123456789012346',
      'expiry_year': '19',
      'expiry_month': '05',
      'csc_cvv': '111',
      '3d_secure_password': 'Not enabled'
    })
    ..add({
      'card_type': 'MASTERCARD',
      'number': '5453010000064154',
      'expiry_year': '19',
      'expiry_month': '05',
      'csc_cvv': '111',
      '3d_secure_password': 'secbarry1'
    })
    ..add({
      'card_type': 'VISA',
      'number': '4123450131001381',
      'expiry_year': '19',
      'expiry_month': '05',
      'csc_cvv': '123',
      '3d_secure_password': 'mctest1'
    })
    ..add({
      'card_type': 'VISA',
      'number': '4123450131001522',
      'expiry_year': '19',
      'expiry_month': '05',
      'csc_cvv': '123',
      '3d_secure_password': 'mctest1'
    })
    ..add({
      'card_type': 'VISA',
      'number': '4123450131004443',
      'expiry_year': '19',
      'expiry_month': '05',
      'csc_cvv': '123',
      '3d_secure_password': 'mctest1'
    })
    ..add({
      'card_type': 'VISA',
      'number': '4123450131000508',
      'expiry_year': '19',
      'expiry_month': '05',
      'csc_cvv': '111',
      '3d_secure_password': 'Not enabled'
    });

  static Map<String, dynamic> getCardIndex(int index) {
    return list_cards[index];
  }

  static List<Map<String, dynamic>> list_merchants = new List()
    ..add({
      'merchant_name': 'Sandbox Party',
      'secret_api_key': 'sk-jZK0i8yZ30ph8xQSWlNsF9AMWfGOd3BaxJjQ2CDCCZb 	',
      'public_facing_api_key': 'pk-nRO7clSfJrojuRmShqRbihKPLdGeCnb9wiIWF8meJE9',
      'use_for': 'Checkout'
    })
    ..add({
      'merchant_name': 'Sandbox Party 2',
      'secret_api_key': 'sk-vb27oxKsTzWTAiil0zvu8aflo4I3h5cvcVCa0HdVyrt',
      'public_facing_api_key': 'pk-zkE0dIHQuDQEdWXJM547lhyX8IXLJRmpQ2tnmVIS5eo',
      'use_for': 'Checkout'
    })
    ..add({
      'merchant_name': 'Sandbox Party 3',
      'secret_api_key': 'sk-SNCvnXbvtAxU6mszPMoDl2M1d4e1ivko1E6PLGiOiqm',
      'public_facing_api_key': 'pk-TnpIh5X432Qw1DJLlMhzxRhBN4fvUp3SHPuHT3m5wv6',
      'use_for': 'Checkout'
    })
    ..add({
      'merchant_name': 'Sandbox Party 4',
      'secret_api_key': 'sk-bi6bdLEfFd1GH6T6bF19vvI3kXc5gvTDJWbpDL3QWeK',
      'public_facing_api_key': 'pk-A8aEsptjZGXar9At3ZPKH0DlUZge5UKXFqloeGDtARm',
      'use_for': 'Checkout'
    })
    ..add({
      'merchant_name': 'Sandbox Party 5',
      'secret_api_key': 'sk-BoTm71oqA1jdCd6bwLwxK3QsVPo9ZOcr1dpYfyAPUUd',
      'public_facing_api_key': 'pk-6y2WX6WhWxfQOg8ezKIUuiJxa7gC4sDvOipn9NFXlwz',
      'use_for': 'Payment Vault'
    });

  static Map<String, dynamic> getApiKeyIndex(int index) {
    return list_merchants[index];
  }

  static String authentication =
      'Basic cGstNnkyV1g2V2hXeGZRT2c4ZXpLSVV1aUp4YTdnQzRzRHZPaXBuOU5GWGx3ejo=';

  static String getAuthentication() {
    return authentication;
  }
}
