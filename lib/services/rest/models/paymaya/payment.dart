class Payment {
  final String PROVIDER = 'paymaya';

  Map<String, dynamic> headers = {
    'Authorization':
        "Basic cGstNnkyV1g2V2hXeGZRT2c4ZXpLSVV1aUp4YTdnQzRzRHZPaXBuOU5GWGx3ejo=",
    'Content-Type': "application/json"
  };

  Map<String, dynamic> request = {
    "paymentTokenId": "",
    "totalAmount": {"amount": "", "currency": "PHP"},
    "buyer": {
      "firstName": "Ysa",
      "middleName": "Cruz",
      "lastName": "Santos",
      "contact": {
        "phone": "+63(2)1234567890",
        "email": "ysadcsantos@gmail.com"
      },
      "billingAddress": {
        "line1": "9F Robinsons Cybergate 3",
        "line2": "Pioneer Street",
        "city": "Mandaluyong City",
        "state": "Metro Manila",
        "zipCode": "12345",
        "countryCode": "PH"
      }
    },
    "requestReferenceNumber": "REF0001234",
    "redirectUrl": {
      "success": "http://shop.someserver.com/success?id=6319921",
      "failure": "http://shop.someserver.com/failure?id=6319921",
      "cancel": "http://shop.someserver.com/cancel?id=6319921"
    }
  };

  Map<String, dynamic> response = {
    "state": "",
    "paymentTokenId": "",
    "createdAt": "",
    "updatedAt": ""
  };

  setRequest(Map<String, dynamic> request) {
    this.request['card'] = request['card'];
    this.request['card']['number'] = request['card']['number'];
    this.request['card']['expMonth'] = request['card']['expMonth'];
    this.request['card']['expYear'] = request['card']['expYear'];
    this.request['card']['cvc'] = request['card']['cvc'];
  }

  setResponse(Map<String, dynamic> response) {
    this.response['state'] = response['state'];
    this.response['paymentTokenId'] = response['paymentTokenId'];
    this.response['createdAt'] = response['createdAt'];
    this.response['updatedAt'] = response['updatedAt'];
  }

  setHeader(Map<String, dynamic> headers) {
    this.headers['Authorization'] = headers['Authorization'];
    this.headers['Content-Type'] = headers['Content-Type'];
  }

  getRequest() {
    return request;
  }

  getResponse() {
    return response;
  }

  getHeader() {
    return headers;
  }
}
