// Constants.h

#define BFDebugLog NSLog
#define BFErrorLog NSLog

#define kdefaultBrokerageAccountName @"Brokerage Account 1"
#define kDefaultExternalAccountName @"External Account 1"
#define kDefaultRoutingNumber 22000248
#define kDefaultExternalAccountNumber 12345678
#define kUSD @"USD"
#define kDefaultTransferAmount 100000

#define kRequestTimeout 30

#define kStringFieldIsEmpty @"Field is Empty"
#define kStringFieldValid @"Valid"
#define CPTColorFromRGB(rgbValue) [CPTColor \
colorWithComponentRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kErrorIconInvalidAtEndOfTextField @"ErrorHandling_AlertIcon.png"
#define kErrorIconValidAtEndOfTextField @"ErrorHandling_CheckIcon.png"

// Dictionary keys
#define kPricePaidPerShare @"pricePaidPerShare"
#define kFirstName @"firstName"
#define kLastName @"lastName"
#define kUsername @"username"
#define kPassword @"password"
#define kUrl @"uri"
#define kRel @"rel"
#define kDetail @"detail"
#define kAccountName @"accountName"
#define kNewAccountName @"newName"
#define kAllAccounts @"All Accounts"
#define kExternalAccountName @"name"
#define kRoutingNumber @"routingNumber"
#define kAccountNumber @"accountNumber"
#define kAmount @"amount"
#define kToAccountId @"toAccountId"
#define kCurrency @"currency"
#define kId @"id"
#define kQuantity @"quantity"
#define kSymbol @"symbol"