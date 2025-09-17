//
//  ClientQuery.swift
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

import UIKit
import MobileBuySDK

final class ClientQuery {

    static let maxImageDimension = Int32(UIScreen.main.bounds.width)
    
    // ----------------------------------
    //  MARK: - Customers -
    //
    static func mutationForLogin(email: String, password: String) -> Storefront.MutationQuery {
        let input = Storefront.CustomerAccessTokenCreateInput(email: email, password: password)
        return Storefront.buildMutation { $0
            .customerAccessTokenCreate(input: input) { $0
                .customerAccessToken { $0
                    .accessToken()
                    .expiresAt()
                }
                .customerUserErrors { $0
                    .code()
                    .field()
                    .message()
                }
            }
        }
    }
    
    static func mutationForLogout(accessToken: String) -> Storefront.MutationQuery {
        return Storefront.buildMutation { $0
            .customerAccessTokenDelete(customerAccessToken: accessToken) { $0
                .deletedAccessToken()
                .userErrors { $0
                    .field()
                    .message()
                }
            }
        }
    }
    
    static func queryForCustomer(limit: Int, after cursor: String? = nil, accessToken: String) -> Storefront.QueryRootQuery {
      return Storefront.buildQuery { $0
        .customer(customerAccessToken: accessToken) { $0
          .id()
          .orders(first: Int32(limit), after: cursor,reverse:true) { $0
            .fragmentForStandardOrder()
          }}}
    }
    
    // ----------------------------------
    //  MARK: - Shop -
    static func mutationResetPassword(email: String) -> Storefront.MutationQuery{
    return Storefront.buildMutation { $0
        .customerRecover(email: email){$0
            .customerUserErrors() { $0
                      .field()
                      .message()
                  }
        }
    }
}

    static func queryForShopName() -> Storefront.QueryRootQuery {
        return Storefront.buildQuery { $0
            .shop { $0
                .name()
            }
        }
    }
    
    static func queryForShopURL() -> Storefront.QueryRootQuery {
        return Storefront.buildQuery { $0
            .shop { $0
                .primaryDomain { $0
                    .url()
                }
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Storefront -
    //
    static func queryForCollectionWithIdt(_ arr:[GraphQL.ID],size:CGSize) -> Storefront.QueryRootQuery {
        let query = Storefront.buildQuery { $0
            .nodes(ids: arr) { $0
                .onCollection { $0
                .id()
                .title()
                  .image { $0
                    .url()
                }
              }
            }
        }
        return query
      }
    
    static func queryForMenuCollectionId(_ arr:[GraphQL.ID]) -> Storefront.QueryRootQuery {
        let query = Storefront.buildQuery { $0
            .nodes(ids: arr) { $0
                .onCollection { $0
                .id()
                .title()
                  .image { $0
                    .url()
                }
              }
            }
        }
        return query
      }
    
    static func queryForMenuId() -> Storefront.QueryRootQuery {
        let query = Storefront.buildQuery { $0
            .menu(handle: "main-menu"){ $0
                .items(){ $0
                    .title()
                    .id()
                    .items(){ $0
                        .title()
                        .id()
                        }
                    }
                .title()
                .id()
            }
        }
        return query
      }
    
    static func queryForCollections(limit: Int, after cursor: String? = nil, productLimit: Int = 25, productCursor: String? = nil) -> Storefront.QueryRootQuery {
        return Storefront.buildQuery { $0
            .collections(first: Int32(limit), after: cursor) { $0
                .pageInfo { $0
                    .hasNextPage()
                }
                .edges { $0
                    .cursor()
                    .node { $0
                        .id()
                        .title()
                        .descriptionHtml()
                        .image { $0
							.url()
                        }
                    }
                }
            }
        }
    }
    
    static func queryForProductsSearch(limit: Int, after cursor: String? = nil,sortKey: Storefront.ProductSortKeys? = nil,reverse:Bool=false,querySearch:String?=nil) -> Storefront.QueryRootQuery {
          let query = Storefront.buildQuery { $0
            .products(first: Int32(limit),after:cursor,reverse:reverse,sortKey:sortKey,query:querySearch) { $0
              .fragmentForStandardProduct()
            }
            
          }
          return query
      }
    
    static func queryForProducts(in collectionId: GraphQL.ID, limit: Int, after cursor: String? = nil,sortKey: Storefront.ProductCollectionSortKeys? = nil,filters: [Storefront.ProductFilter]? = nil,reverse:Bool=false) -> Storefront.QueryRootQuery {
        
        return Storefront.buildQuery { $0
            .node(id: collectionId) { $0
                .onCollection { $0
                    .products(first: Int32(limit), after: cursor,reverse:reverse,sortKey:sortKey,filters: filters){ $0
                        .fragmentForStandardProduct()
                        .filters{ $0
                            .id()
                            .label()
                            .type()
                            .values{ $0
                                .id()
                                .input()
                                .label()
                                .count()
                            }
                        }
                    }
                }
            }
        }
    }
    
     //product types
    static func queryForProductsType() -> Storefront.QueryRootQuery {
          let query = Storefront.buildQuery { $0
              .productTypes(first:50) { $0
                  .edges{ $0
                      .node()
                  }
              }
          }
          return query
      }
    
    static func queryForProductsWishlist(_ arr:[GraphQL.ID]) -> Storefront.QueryRootQuery {
      let query = Storefront.buildQuery { $0
          .nodes(ids: arr) { $0
              .onProduct { $0
                 .fragmentForStandardProductDtl()
              }
          }
      }
      
      return query
    }
          
    
    static func queryForProductsDetails(_ productId: GraphQL.ID) -> Storefront.QueryRootQuery {
        return  Storefront.buildQuery { $0
            .product(id: productId) { $0
                .fragmentForStandardProductDtl()
                
            }
        }
        
    }

    
    // product recommandation
    static func queryForProductsRecomandation(in productId: GraphQL.ID, limit: Int, after cursor: String? = nil) -> Storefront.QueryRootQuery {
      
      return Storefront.buildQuery { $0
        .productRecommendations(productId:productId) { $0
          .fragmentForStandardProductDtl()
          
        }
      }
    }
    // ----------------------------------
    //  MARK: - Discounts -
    //
    static func mutationForApplyingDiscount(_ discountCode: String, to checkoutID: String) -> Storefront.MutationQuery {
        let id = GraphQL.ID(rawValue: checkoutID)
        return Storefront.buildMutation { $0
            .checkoutDiscountCodeApplyV2(discountCode: discountCode, checkoutId: id) { $0
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
                .checkout { $0
                    .fragmentForCheckout()
                }
            }
        }
    }
    
    static  func productVariantListIdsQuery(_ nodeIds: [GraphQL.ID]) -> Storefront.QueryRootQuery {
        return Storefront.buildQuery{ $0
            .nodes(ids: nodeIds, { $0
                .onProductVariant(subfields: productVariantQuery())
            })
        }
       }
   
     static  private func productVariantQuery() -> (Storefront.ProductVariantQuery) -> Void {
           return { (query: Storefront.ProductVariantQuery) in
               query.id()
               query.title()
               query.availableForSale()
               query.image{ $0
                   .url()
               }
               query.selectedOptions{ $0
                   .name()
                   .value()
               }
                query.compareAtPrice{ $0
                .amount()
                }
              query.quantityAvailable()
              query.selectedOptions{$0
              .name()
              .value()
              }
             query.product{$0
               .id()
               .title()
               .vendor()
             }
              query.currentlyNotInStock()
              query.price { $0
              .amount()
              .currencyCode()
                }
           }
       }
    // ----------------------------------
    //  MARK: - Gift Cards -
    //
    static func mutationForApplyingGiftCard(_ giftCardCode: String, to checkoutID: String) -> Storefront.MutationQuery {
        let id = GraphQL.ID(rawValue: checkoutID)
        return Storefront.buildMutation { $0
            .checkoutGiftCardsAppend(giftCardCodes: [giftCardCode], checkoutId: id) { $0
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
                .checkout { $0
                    .fragmentForCheckout()
                }
            }
        }
    }
    
    static func mutationEditUser(customerAccessToken: String,firstName:String,lastName:String,phone:String) -> Storefront.MutationQuery {
        let customerUpdateInput = Storefront.CustomerUpdateInput.create(
              firstName: Input.value(firstName),
              lastName: Input.value(lastName),
              phone: Input.value(phone)
             
          )

          return Storefront.buildMutation { $0
              .customerUpdate(customerAccessToken: customerAccessToken, customer: customerUpdateInput) { $0
                  .customer() { $0
                      .firstName()
                      .lastName()
                      .phone()
                  }
                  .customerUserErrors() { $0
                      .code()
                      .field()
                      .message()
                  }
              }
          }
      }
    
    static func mutationForCreateUser(firstName:String,lastName:String, email:String,mobile:String,password:String,acceptMarketEmail:Bool) -> Storefront.MutationQuery {
        let addressInput = Storefront.CustomerCreateInput(email: "\(email)", password: "\(password)",firstName: "\(firstName)",lastName: "\(lastName)", phone: "\(mobile)", acceptsMarketing: acceptMarketEmail)
        return Storefront.buildMutation { $0
            .customerCreate(input: addressInput){ $0
                .customer(){ $0
                    .id()
                    .email()
                    .firstName()
                    .phone()
                    .acceptsMarketing()
                    
                }
                .customerUserErrors(){ $0
                    .code()
                    .field()
                    .message()
                    
                }
                
            }
            
                
        }
    }
    
    static func queryForUserAddress( accessToken: String) -> Storefront.QueryRootQuery {
       return Storefront.buildQuery { $0
         .customer(customerAccessToken: accessToken)
         { $0
           
           .defaultAddress{ $0
             .id()
             .firstName()
             .lastName()
             .company()
             .address1()
             .address2()
             .city()
             .province()
             .provinceCode()
             .country()
             .zip()
             .phone()
             .countryCodeV2()
         }
         .addresses(first: 10)
         { $0
           .pageInfo
           { $0
             .hasNextPage()
         }
         .edges { $0
         .node { $0
         .id()
         .firstName()
         .lastName()
         .address1()
         .address2()
         .city()
         .province()
         .country()
         .zip()
         .phone()
         .countryCodeV2()
           }}}}}}
    
    static func mutationSetUserDefaultAddress(accessToken:String,Id:String) -> Storefront.MutationQuery {
      return Storefront.buildMutation{ $0
        .customerDefaultAddressUpdate(customerAccessToken: accessToken, addressId: GraphQL.ID(rawValue: Id), { $0
          .customer{ $0
            .defaultAddress{ $0
              .id()
            }}
          .customerUserErrors{ $0
            .field()
            .message()
          }})}}
    
    static func mutationAddUserAddress(accessToken:String,address:String,address2:String,city:String,zip:String,province:String,phone:String) -> Storefront.MutationQuery {
      let input = Storefront.MailingAddressInput.create(
        address1:  Input.value(address),
        address2: Input.value(address2),
        city:      Input.value(city),
        country:   .value("India"),
        phone:     Input.value(phone), province:  Input.value(province),
        zip:       Input.value(zip)
      )
      return  Storefront.buildMutation { $0
        .customerAddressCreate(customerAccessToken:accessToken, address: input) { $0
          .customerAddress { $0
            .id()
            .firstName()
            .lastName()
            .city()
            .province()
            .country()
            .phone()
            .zip()
            .id()
            .address1()
            .address2()
        }
        .customerUserErrors { $0
        .field()
        .message()
          }}
      }}
    
    static func mutationUpdateUserAddress(accessToken:String,id:String,address:String,address2:String,city:String,zip:String,province:String,phone:String) -> Storefront.MutationQuery {
      let input = Storefront.MailingAddressInput.create(
        address1:  Input.value(address),
        address2: Input.value(address2),
        city:      Input.value(city),
        country:   .value("India"),
        phone:     Input.value(phone), province:  Input.value(province),
        zip:       Input.value(zip)
      )
      return  Storefront.buildMutation{ $0
        .customerAddressUpdate(customerAccessToken: accessToken, id: GraphQL.ID(rawValue: id), address: input, { $0
          .customerAddress{ $0
            .id()}
          .customerUserErrors{ $0
            .field()
            .message()
          }
        })}}
    
    static func mutationDeleteUserAddress(accessToken:String,id:String) -> Storefront.MutationQuery {
      return  Storefront.buildMutation{ $0
        .customerAddressDelete(id: GraphQL.ID(rawValue: id), customerAccessToken: accessToken) { $0
          .customerUserErrors{ $0
            .field()
            .message()
          }
        }}}
    
    // ----------------------------------
    //  MARK: - Checkout -
    //
    static func mutationForCreateCheckout(with cartItems: [CartItem]) -> Storefront.MutationQuery {
        let lineItems = cartItems.map { item in
            Storefront.CheckoutLineItemInput.create(quantity: Int32(item.quantity), variantId: GraphQL.ID(rawValue: item.variantId))
        }
        
        let checkoutInput = Storefront.CheckoutCreateInput.create(
            lineItems: .value(lineItems),
            allowPartialAddresses: .value(true)
        )
        
        return Storefront.buildMutation { $0
            .checkoutCreate(input: checkoutInput) { $0
                .checkout { $0
                    .fragmentForCheckout()
                }
                .checkoutUserErrors{$0
                    .field()
                    .message()
                }
            }
        }
    }
    
    static func queryForCheckout(_ id: String) -> Storefront.QueryRootQuery {
        Storefront.buildQuery { $0
            .node(id: GraphQL.ID(rawValue: id)) { $0
                .onCheckout { $0
                    .fragmentForCheckout()
                }
            }
        }
    }
    
    static func queryForUserProfile( accessToken: String) -> Storefront.QueryRootQuery {
      return Storefront.buildQuery { $0
        .customer(customerAccessToken: accessToken) { $0
          .id()
          .defaultAddress{ $0
            .zip()
           }
          .displayName()
          .email()
          .firstName()
          .lastName()
          .phone()
          .updatedAt()
        }}}
    
    static func mutationForUpdateCheckout(_ id: String, updatingPartialShippingAddress address: PayPostalAddress) -> Storefront.MutationQuery {
        
        let checkoutID   = GraphQL.ID(rawValue: id)
        let addressInput = Storefront.MailingAddressInput.create(
            city:     address.city.orNull,
            country:  address.country.orNull,
            province: address.province.orNull,
            zip:      address.zip.orNull
        )
        
        return Storefront.buildMutation { $0
            .checkoutShippingAddressUpdateV2(shippingAddress: addressInput, checkoutId: checkoutID) { $0
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
                .checkout { $0
                    .fragmentForCheckout()
                }
            }
        }
    }
    
    static func mutationForUpdateCheckout(_ id: String, updatingCompleteShippingAddress address: PayAddress) -> Storefront.MutationQuery {
        
        let checkoutID   = GraphQL.ID(rawValue: id)
        let addressInput = Storefront.MailingAddressInput.create(
            address1:  address.addressLine1.orNull,
            address2:  address.addressLine2.orNull,
            city:      address.city.orNull,
            country:   address.country.orNull,
            firstName: address.firstName.orNull,
            lastName:  address.lastName.orNull,
            phone:     address.phone.orNull,
            province:  address.province.orNull,
            zip:       address.zip.orNull
        )
        
        return Storefront.buildMutation { $0
            .checkoutShippingAddressUpdateV2(shippingAddress: addressInput, checkoutId: checkoutID) { $0
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
                .checkout { $0
                    .fragmentForCheckout()
                }
            }
        }
    }
    
    static func mutationForUpdateCheckout(_ id: String, updatingShippingRate shippingRate: PayShippingRate) -> Storefront.MutationQuery {
        
        return Storefront.buildMutation { $0
            .checkoutShippingLineUpdate(checkoutId: GraphQL.ID(rawValue: id), shippingRateHandle: shippingRate.handle) { $0
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
                .checkout { $0
                    .fragmentForCheckout()
                }
            }
        }
    }
    
    static func mutationForUpdateCheckout(_ id: String, updatingEmail email: String) -> Storefront.MutationQuery {
        
        return Storefront.buildMutation { $0
            .checkoutEmailUpdateV2(checkoutId: GraphQL.ID(rawValue: id), email: email) { $0
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
                .checkout { $0
                    .fragmentForCheckout()
                }
            }
        }
    }
    
    static func mutationForUpdateCheckout(_ checkoutID: String, associatingCustomer accessToken: String) -> Storefront.MutationQuery {
        let id = GraphQL.ID(rawValue: checkoutID)
        return Storefront.buildMutation { $0
            .checkoutCustomerAssociateV2(checkoutId: id, customerAccessToken: accessToken) { $0
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
                .checkout { $0
                    .fragmentForCheckout()
                }
            }
        }
    }
    
    static func mutationForCompleteCheckoutUsingApplePay(_ checkout: PayCheckout, billingAddress: PayAddress, token: String, idempotencyToken: String) -> Storefront.MutationQuery {
        
        let mailingAddress = Storefront.MailingAddressInput.create(
            address1:  billingAddress.addressLine1.orNull,
            address2:  billingAddress.addressLine2.orNull,
            city:      billingAddress.city.orNull,
            country:   billingAddress.country.orNull,
            firstName: billingAddress.firstName.orNull,
            lastName:  billingAddress.lastName.orNull,
            province:  billingAddress.province.orNull,
            zip:       billingAddress.zip.orNull
        )
        
        let currencyCode  = Storefront.CurrencyCode(rawValue: checkout.currencyCode)!
        let paymentAmount = Storefront.MoneyInput(amount: checkout.paymentDue, currencyCode: currencyCode)
        let paymentInput  = Storefront.TokenizedPaymentInputV3.create(
            paymentAmount:  paymentAmount,
            idempotencyKey: idempotencyToken,
            billingAddress: mailingAddress,
            paymentData:    token,
            type:           Storefront.PaymentTokenType.applePay
        )
        
        return Storefront.buildMutation { $0
            .checkoutCompleteWithTokenizedPaymentV3(checkoutId: GraphQL.ID(rawValue: checkout.id), payment: paymentInput) { $0
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
                .payment { $0
                    .fragmentForPayment()
                }
            }
        }
    }
    
    static func queryForPayment(_ id: String) -> Storefront.QueryRootQuery {
        return Storefront.buildQuery { $0
            .node(id: GraphQL.ID(rawValue: id)) { $0
                .onPayment { $0
                    .fragmentForPayment()
                }
            }
        }
    }
    
    static func queryShippingRatesForCheckout(_ id: String) -> Storefront.QueryRootQuery {
        
        return Storefront.buildQuery { $0
            .node(id: GraphQL.ID(rawValue: id)) { $0
                .onCheckout { $0
                    .fragmentForCheckout()
                    .availableShippingRates { $0
                        .ready()
                        .shippingRates { $0
                            .handle()
                            .price { $0
                                .amount()
                                .currencyCode()
                            }
                            .title()
                        }
                    }
                }
            }
        }
    }
}
