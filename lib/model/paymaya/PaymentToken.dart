class PaymentToken {

  static final String PROVIDER = 'paymaya';


  Map<String, dynamic> headers = {
    'Authorization': "",
    'Content-Type': ""
  };

  Map<String, dynamic> request = {
    'card': {
      'number': "",
      'expMonth': "",
      'expYear': "",
      'cvc': "",
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