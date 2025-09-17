//
//  Fragment+OrderConnectionQuery.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import MobileBuySDK

extension Storefront.OrderConnectionQuery {
    
    @discardableResult
    func fragmentForStandardOrder() -> Storefront.OrderConnectionQuery { return self
        .pageInfo { $0
            .hasNextPage()
        }
        .edges { $0
            .cursor()
            .node { $0
                .id()
                .orderNumber()
                .email()
            .financialStatus()
            .fulfillmentStatus()
            .currencyCode()
            .processedAt()
            .statusUrl()
            
            .successfulFulfillments{ $0
            .trackingCompany()
            .trackingInfo{$0
            .number()
            .url()
              }
            }
            .shippingAddress { $0
            .id()
                .firstName()
                .lastName()
                .phone()
                .address1()
                .address2()
                .city()
                .country()
                .countryCodeV2()
                .province()
                .provinceCode()
                .zip()
            }
            .subtotalPrice{ $0
                .amount()
                .currencyCode()
            }
            .totalShippingPrice{ $0
                .amount()
                .currencyCode()
            }
            .totalTax{ $0
                .amount()
                .currencyCode()
            }
            .lineItems(first: Int32(10)){  $0
                .fragmentForStandardLineItem()
              }
                .totalPrice{ $0
                    .amount()
                    .currencyCode()
                }
            }
        }
    }
}

