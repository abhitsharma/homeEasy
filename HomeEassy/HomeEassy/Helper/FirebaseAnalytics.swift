//
//  FirebaseAnalytics.swift
//  HomeEassy
//
//  Created by Macbook on 24/01/24.
//

import Foundation
import Firebase
import FirebaseAnalytics
let kEventCategoryListing = "listing_page"
let kGTMEventListingWishlist = "product_listing_wishlist" // 1
let kGTMEventAllScreenView = "all_screen_view" // 0
let kEventCategoryLogin = "Log In"
let kGTMEventMyAccountPasswordUpdate = "my_account_password-update"
let kEventActionWishlistAdd = "Added"
let kEventActionWishlistRemove = "Removed"
let kGTMEventHamburgerMyWishlist = "hamburger_menu_my-wishlist" // 1
let kGTMEventHamburgerMenuClick = "hamburger_menu_click"
let kGTMEventDetailAddToBag = "product_detail_add-to-bag"
let kActionAdd = "Added"
let kActionRemove = "Removed"

let kKeyGender = "Gender"
let kKeyUserId = "UserID"
let kKeyitems = "items"
let kKeypromotions = "promotions"
let kKeyDynamic = "Dynamic"
let kEventCategorySelectShopEvent = "tvc_select_shop"
let kEventCategorySelectShop = "Select Shop"
let kECategoryHamburgerMenu = "Hamburger Menu"
let kGTMEventProductListingView = "tvc_listing_view_type" // 1
let kECategoryListingView = "Listing Screen"
let kKeyScreenName = "screen_name"
let kValueListName = "product_listing_title"
let kKeyopenScreen = "openScreen"
let kKeyAdvertisingID = "Advertising ID"
let kKeyContainerID = "Container ID"
let kKeyEvent = "eventName"
let kKeyAction = "eventAction"
let kKeyLabel = "eventLabel"
let kEventCategory = "eventCategory"
let kGTMEventHomeHamburger = "tvc_hamburger_open" // 1
let kGTMEventThanksYou = "thank_you_screen"


//****************************  Ankit ********************************

let kEventHomeCategoryView = "tvc_home_category_view"
let kEventInstallReceiver = "install_receiver"//not implemented
let kCategoryInstallReceiver = "install_referral_tracking"//not implemented
let kGTMEventHamburgerMenuLevel1 = "tvc_hamburger_level1"
let kCategoryHamburgerMenu = "Hamburger Menu"
let kGTMEventHamburgerMenuLevel2 = "tvc_hamburger_level2"
let kGTMEventHamburgerMenuLevel3 = "tvc_hamburger_level3"
let kGTMEventListingSortBy = "tvc_listing_sortby"
let kEventListingSortByOption = "tvc_listing_sortby_option"
let kEventListingFilter = "tvc_listing_filter"
let kEventListingFilterApply = "tvc_listing_filter_apply"
let kEventListingFilterClearAll = "tvc_listing_filter_clearall"//not implemented
let kEventSortAction = "Sort By"
let kFiltersAction = "Filters"
let kInitiateLabel = "Initiate"
let kClearAllLabel = "Clear All"//not implemented
let kEventSearchInitiate = "tvc_search_initiate"
let kEventSearchtrending = "tvc_search_trending"
let kEventSearchkeyword  =  "tvc_search_keyword"
let kEventCategorySearch = "Search"
let kSerchCount = "Search Count"
let kOpenLabel = "open"
let kCloseLabel = "close"
let kSimilerAction  = "Similar Products"
let kGTMSimilarProducts = "tvc_listing_similar_products"
let kEventSocialMedia = "tvc_hamburger_socialmedia"
let KSocialMediaAction = "Social Media"
let kEventViewAll = "tvc_home_screen_product_viewall"
let kEventCategoryViewAll = "Home Screen"
let kViewAllAction = "Products Slider"
let kViewAllLabel = "- View All"
let kEventProductClick = "tvc_listing_prodclick"
let kProductClickAction  = "Product Click"
let kTrendingAction = "Trending" //common
let kProductDiscountPercent = "product_discount_percent"
let kdiscounted_price = "discounted_price"
let kmarkup_price = "markup_price"
let kEventCouponApply = "tvc_mybag_apply_coupon"
let kEventCategoryBag = "My Bag"
let kCouponAction = "Apply Coupon"
let kEventMoreFromWishlist = "tvc_mybag_product_option"//not implemented
let kEventWishListToBag  = "tvc_mywishlist_move_to_bag_product"
let kEventCategoryMyWishList  = "My Wishlist"
let kMovetoBagAction = "Move to Bag"
let kEventUpdateBag = "tvc_mybag_add_from_wishlist_complete"
let kAddFromWishListAction = "Add More From Wishlist"
let kEventRemoveFromBag = "tvc_mybag_product_remove"
let kProductAction = "Product"
let kRemoveLabel = "Remove"
let kEventBagMoveToWishlist  = "tvc_mybag_product_movetowishlist"
let kBagMoveToWishlistLabel  = "Move to Wishlist"
let kEventChangeAddress = "tvc_order_summary_change_address"
let kEventCategoryOrderSummary = "Order Summary"
let kChangeAddresAction = "Change Delivery Address"
let koderAmmountOnAddressChange = "order_amount"
let kEventAddressEdit = "tvc_address_edit"
let kEventCategoryAddress = "Address"
let kEditAddressAction = "Edit"
let kEventAddressUpdate = "tvc_address_update"
let kUpdatedAddressAction = "Updated"
let kEventDetailDownArrow  = "tvc_payment_payamountactivity"
let kEventCategoryPayment = "Payment"
let kPayAmountAction = "Pay Amount"
let kPaymentMode = "Payment Mode"
let kEventPaymentOption  = "tvc_payment_select_option"
let kPaymentOptionAction = "Payment Option Selected"
let kEventContinueShopping = "tvc_thankyou_continue_shopping"
let kEventThankYouCategory = "Thank You"
let kContinueShoppingAction = "CONTINUE SHOPPING"
let kThankYouRatingsAction = "Ratings"
let kEventThankYouRating = "tvc_thankyou_rating"
let kCategoryGender = "gender"
let kPromoCode = "Coupon_Code"
let kPromoDiscountPercentage = "Discount_Percentage"
let kPromoSubTotal = "sub_Total"
let kPayAmount = "payAmount"
let kEditsize = "Edit - size - "
let kkeyActionSelectSize = "Select Size"
let kPaymentfail = "tvc_payment_fail"
let kQuickCheckout="quick_checkout"
// new key zubin
let kselectedSize = "cp2"
let kMrpKey = "cp1"
let kStockStatus = "stockStatus"
let kDeliveryText = "deliveryText"
let kImageUrl = "content"
let keventValue = "eventValue"
// new key ATUL
let kLoginAction = "Logged In"
let kLoginSession = "Login Session"
let kLogoutAction = "Logged Out"
let kLoginStatus = "login_session_status"
let kReferEarn = "refer_earn"
let kReferEarnClicked="refer_earn_clicked"
let kReferralCodeShown="referral_code_shown"
let kReferralCodeShare="referral_code_share"
let kReferralCodeCopied="referral_code_copied"
let kReferEarnRegistration = "refer_earn_registration"
let kReferralUseSignup="Referral_use_signup"
let kReferralUserEmail="referral_user_email"
let kReferralAlreadyRegistered="referral_already_registered"
let kReferralCodeStarted="referral_code_started"
let kReferralCodeInput="referral_code_input"
let kReferralCodeStatus="referral_code_status"
let kReferralMobileRegistered="referral_mobile_registered"
let kReferralOtpStatus="referral_otp_status"
let kReferralCodeSuccess="referral_code_success"
let kEventInAPpMsz = "inapp_message"

////private let kListingPageName = "productlisting" discuss with swaty Sir

//*********************************   priyanka    **********************************

let kGTMEventDetailProductDetail = "tvc_detail_prod_detail"
let kEventListingSimilarProduct = "tvc_listing_similar_products"
let kEventAddToWishlist = "tvc_detail_addtowishlist"
let kGTMEventDetailShareAction = "tvc_detail_share" // 1
let kGTMEventDetailInfo = "tvc_detail_info" // 1
let kGTMEventInfoIcon = "Info Icon" // 1
let kGTMEventActionWishlist = "Wishlist" // 1
let kGTMEventDetailSizeGuide = "tvc_detail_sizeguide" // 1
let kGTMEventDetailSelectSize = "tvc_detail_selectsize" // 1
let kGTMEventDetailPincode = "tvc_detail_pincode" // 1
let kSizeGuide = "Size Guide"
let kGTMEventLogin = "tvc_login_status"
let kGTMEventLoginSignUp = "tvc_login_signup"
let kEventActionForgotPassword = "tvc_login_forgot_password"
let kForgotPassword = "Forgot Password"
let kEventActionPasswordReset = "tvc_login_reset_password"
let kEventActionPasswordResend = "tvc_login_reset_pwd_resend_mail"
let kGTMEventContinueShopping = "tvc_login_reset_pwd_continue_shopping"
let kGTMEventActionSignUpStatus = "tvc_signup_status"
let kGTMEventMyAccountAddAddress = "tvc_address_addnew" // 1
let kGTMEventMyAccountSetDefaultAddress = "tvc_address_default" //1
let kGTMEventActionContactUs = "tvc_contactus_clicktocall"
let kGTMEventDetailImageSwipe = "tvc_detail_image_swipe" // 1
let kGTMEventPercentageSizeAvail = "percentage_size_avail" // 1
let kOutOfStock = "out_of_stock"
let kEventCategoryDetailScreen = "Detail Screen"
let kShare = "Share"
let kGoToBag = "Go to Bag"
let kEventDetailFullImageClick = "tvc_detail_image_fullscreen"
let kGTMEventMyAccountTap = "tvc_myaccount_setting" // 1
let kEventCategoryContactUs = "Contact Us"
let kEventCategoryMyAccount = "My Account"
let kGTMEventMyAccountProfileUpdate = "tvc_myaccount_setting_update" // 1
let kEventActionContactUsOpen = "Click to Call"
let kEventActionMyAccountMenu = "tvc_myaccount_menu"
let kEventActionLogout = "Log Out"
let kGTMEventLogout = "tvc_myaccount_logout"
let kGTMEventCancelOrder = "tvc_myorders_order_cancel"
let kEventCatMyOrder = "My Orders"
let kEventActionOrderDetail = "Order Detail"
let kEventLabelCancel = "Cancel"
let kGTMEventConfirmAndCancel = "tvc_myorders_order_confirmandcancel"
let kEventLabelConfirmAndCancel = "Confirm & Cancel"
let kEventLabelCancelledReason = "Cancelled Reason"
let kGTMPaymentMode = "payment_mode"
let kGTMCancelReason = "cancel_reason"
let kGTMEventHamburgerTrackOrder = "tvc_myorders_order_open" // 1
let kGTMEventDetailGoToBag = "tvc_detail_gotobag" // 1
let kEventActionMail = "email"
let kEventActionSetting = "Settings"
let kEventSignup = "Sign Up"
let kMode = "Mode"
let kSignupSuccess = "You have been successfully registered!"
let kLoginSuccess = "success"
let kLoginFail = "fail"
let kImagePosition = "Login Successful!"
let kSelectContent = "select_content"
let kSerchOption = "search_option"
let kLabelLogin = "login"
let kOpenLabelCaps = "Open"
let kINR = "INR"
let kProductListing  = "Product Listing"
let kRecommendedList = "recommended list"
let kShopBrand = "shop brand collection"
let kGTMEventOrderExchange = "tvc_myorders_order_exchange"
let kLabelExchange = "Exchange"
let kGTMEventOrderConfirmExchange = "tvc_myorders_order_confirmandexchange"
let kLabelConfirmExchange = "Confirm & Exchange"
let kGTMEventOrderReturn = "tvc_myorders_order_return"
let kLabelReturn = "Return"
let kGTMEventOrderConfirmReturn = "tvc_myorders_order_confirmandreturn"
let kLabelConfirmReturn = "Confirm & Return"
let kGTMEventNeedHelp = "tvc_myorders_need_help"
let kLabelNeedHelp = "Need Help for Order?"
let kLabelReturnReason = "return_reason"
//let kKeyQuantity = AnalyticsParameterQuantity
// New EVENT add by atul
let kSuccessfulPaymentMethod = "successful_payment_method"
let kPaymentMethodUsed = "payment_method_used"
let kPaymentMethodValue = "payment_method_value"
// ADD EVENT FOR PRICE AFTER SELL
let kaspEventName = "asp_available"
let kskuASPEventValue = "sku_id"
let kaspEventValue = "asp_value"
// ADD EVENT FOR Brought Erlier Indicator
let kSizeSuggestionEventName = "size_suggestion"
let kSuggestionTypeEventValue = "suggestion_type"
let kProductidEventValue = "product_id"
let kCustomDimensionSize = "product_size"
let kCustomDimensionName = "product_name"
let kCustomDimensionPrice = "product_price"
let kCustomDimensionBrand = "product_brand"
let kCustomDimensionCategory = "product_cateogry"
let kCustomDimensionSubCategory = "product_subcategory"
let kCustomDimensionProductImage = "product_images"
let kCustomDimensionProductId = "product_id"
let kCustomDimensionLineId = "line_id"
let kCustomDimensionColor = "product_colour"
let kCustomDimensionDiscountPercent = "product_discount_percent"
let kCustomDimensionDiscountPrice = "discounted_price"
let kCustomDimensionMarkupPrice = "markup_price"
let kCustomDimensionImagePosition = "image_position"
let kCustomDimensionSKUID = "sku_id"
let kCustomDimensionquantity = "quantity"

let kKeyName = "AnalyticsParameterItemName"
let kKeyId = "AnalyticsParameterItemName"
let kKeyPrice = "AnalyticsParameterItemName"
let kKeyBrand = "AnalyticsParameterItemName"
let kKeyCategory = "AnalyticsParameterItemName"
let kKeyVariant = "AnalyticsParameterItemName"
let kKeyPosition = "AnalyticsParameterItemName"
let kKeyCreative = "AnalyticsParameterItemName"
let kCurrency = "AnalyticsParameterItemName"
let kCreativeSlot = "AnalyticsParameterItemName"

class FirebaseAnalytics{
    static let shared = FirebaseAnalytics()
    func sendLogEventProduct(name:String,id:String,varint:String){
        let selectedItem: [String: Any] = [
            AnalyticsParameterItemListID: id,
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemVariant: varint,
        ]
         Analytics.logEvent("view_item_last", parameters:selectedItem)
    }
    
    func sendLogEventLogin(aacessToken:String){
//        var selectedItem: [String: Any] = [
//        ]
        Analytics.setUserID(aacessToken)
        Analytics.logEvent("login", parameters: nil )
    }
    
    func sendUserAddCartEvent(item:String){
        let cartParamater: [String: Any] = [
                AnalyticsParameterItemListID: item
            ]
        Analytics.logEvent("add_to_cart", parameters: cartParamater)
    }
    
    func sendUserCartEvent(price:String){
            var orderParameters: [String: Any] = [
              AnalyticsParameterItems : CartController.shared.items
            ]
        //Analytics.logEvent(AnalyticsEventViewCart, parameters: orderParameters)
    }
    
    func sendLogEventWishlist(item:String){
        let selectedItem: [String: Any] = [
            AnalyticsParameterItemListID: item,
        ]
         Analytics.logEvent("add_to_wishlist", parameters:selectedItem)
    }
    
    func sendLogEventWishlist(item:ProductObj){
        let selectedItem: [String: Any] = [
            AnalyticsParameterItemListID: item.id
        ]
         Analytics.logEvent("add_to_wishlist", parameters:selectedItem)
    }
}
