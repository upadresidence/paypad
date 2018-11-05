


# API

An Api for rest payments

## Dependencies

http library is required ay pubspec.yaml

```
dependencies:
  flutter:
    sdk: flutter

  http: ^0.11.3+17
```

## How to use:

### 1. import a model to be used
```
import '(your_app_id_here)/services/rest/models/PaymentToken.dart';
```

### 2 instantiate and populate the Model, 
#### FIRST: get the info from the user
```
var number = 4123450131000508;
var exp_month = 05
var exp_year = 2019
var cvc = 123
```



#### SECOND: make the model and populate it with request and header. 
#### NOTE: for sandbox use the STATIC CLASS import '(your_app_id_here)/services/rest/models/SandboxPaymayaCredential.dart';, then SandboxPaymayaCredential.getAuthentication() for the authentication
```
PaymentToken payment_token = new PaymentToken();

Map<String, dynamic> request = {
                                'card': {
                                'number': number,
                                'expMonth': exp_month,
                                'expYear': exp_year,
                                'cvc': cvc
                                }
                            };

payment_token.setRequest(request);
payment_token.setAuthentication(SandboxMaymayaCredential.getAuthentication());
```

### 3 use the Api class import '(your_app_id_here)/services/rest/Api.dart'; to execute the api

#### FIRST: simport the api class 
```
import '(your_app_id_here)/services/rest/Api.dart';
```

#### SECOND: execute the api's request with an action on what to execute;
```
String action = 'token'
var response = Api.executeRequest(payment_token, 'token');
payment_token.setResponse(response);
```

#### THIRD: get the PAYMENT_TOKEN_ID  of the request
```
String payment_token.getResponse()['paymentTokenId'];
```
### 4 populate the payment and put the token
```
var request = {
  "paymentTokenId": payment_token,
  "totalAmount": {
    "amount": 100,
    "currency": "PHP"
  },
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
  
};
```

```

