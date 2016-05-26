//
//  ABConfigure.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/18.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#ifndef ABConfigure_h
#define ABConfigure_h


#define BEGIN	@"BEGIN:"
#define VERSION @"VERSION:"
#define END	@"END:"
#define REV	@"REV:"
#define N	@"N:"
#define FN	@"FN:"
#define ORG	@"ORG:"
#define TITLE	@"TITLE:"
//#define SOUND "SOUND:"  // Not fully supported.
#define ADR	@"ADR:"
#define EMAIL	@"EMAIL:"
//#define NOTE @"NOTE:"
#define	TEL	@"TEL:"
#define ROLE	@"ROLE:"
#define PHOTO	@"PHOTO:"
//#define LOGO	"LOGO:"
#define URL	@"URL:"
// Valid property names not supported (not appropriately handled) by our vCard importer now.
#define AGENT	@"AGENT:"
// Available in vCard 3.0. Shoud not use when composing vCard 2.1 file.
#define NAME	@"NAME:"
#define NICKNAME	@"NICKNAME:"
#define BDAY	@"BADY:"  // Birthday
#define SORTSTRING	@"SORT-STRING:"
#define NOTE	@"NOTE:"
#define IM  @"X-IM:"
#define SNS  @"X-SNS:"

#define ANNIVERSARY @"ANNIVERSARY:"

#define XEVENT @"X-EVENT:"

#define XGROUPCODE  @"X-GROUPCODE:"
//#define XIMAGEDATA  @"X-IMAGEDATA:"

#define DATE    @"DATE:"
/////////////////////////////////////////////
#define BEGIN1	@"BEGIN;"
#define VERSION1 @"VERSION;"
#define END1	@"END;"
#define REV1	@"REV;"
#define N1	@"N;"
#define FN1	@"FN;"
#define ORG1	@"ORG;"
#define TITLE1	@"TITLE;"
//#define SOUND "SOUND:"  // Not fully supported.
#define ADR1	@"ADR;"
#define EMAIL1	@"EMAIL;"
//#define NOTE @"NOTE:"
#define TEL1	@"TEL;"
#define ROLE1	@"ROLE;"
#define PHOTO1	@"PHOTO;"
//#define LOGO	"LOGO:"
#define URL1	@"URL;"
// Valid property names not supported (not appropriately handled) by our vCard importer now.
#define AGENT1	@"AGENT;"
// Available in vCard 3.0. Shoud not use when composing vCard 2.1 file.
#define NAME1	@"NAME;"
#define NICKNAME1	@"NICKNAME;"
#define BDAY1	@"BADY;"  // Birthday
#define SORTSTRING1	@"SORT-STRING;"
#define NOTE1	@"NOTE;"
#define IM1  @"X-IM;"
#define SNS1  @"X-SNS;"

#define ANNIVERSARY1 @"ANNIVERSARY;"
#define XEVENT1 @"X-EVENT;"

#define XGROUPCODE1  @"X-GROUPCODE;"
#define DATE1    @"DATE;"
#define GROUP    @"X-GROUP:"
#define GROUP1    @"X-GROUP;"

#define XRELATION @"X-RELATION:"
#define XRELATION1 @"X-RELATION;"


//add new
#define LASTSAVEDATE                @"REV"
#define BRITHDAY                    @"BRITHDAY"
#define FIRSTNAMEPHONETHIC          @"X-PHONETIC-FIRST-NAME"
#define LASTNAMEPHONETHIC           @"X-PHONETIC-LAST-NAME"
#define MIDDLENAMEPHONETHIC         @"X-PHONETIC-MIDDLE-NAME"

#define PROPERTY                    @"PROPERTY;"
#define SERVICEKEY                  @"SERVICEKEY"
#define SERVICEYAHOO                @"SERVICEYAHOO:"
#define SERVICEJABBER               @"SERVICEJABBER:"
#define SERVICEMSN                  @"SERVICEMSN:"
#define SERVICEICQ                  @"SERVICEICQ:"
#define SERVICEAIM                  @"SERVICEAIM:"
#define USERNAMEKEY                 @"USERNAMEKEY"

//#define NAMESPROPERTY               @"NAMESPROPERTY;"

#define FATHER                      @"FATHER"
#define MOTHER                      @"MOTHER"
#define PARENT                      @"PARENT"
#define BROTHER                     @"BROTHER"
#define SISTER                      @"SISTER"
#define CHILD                       @"CHILD"
#define FRIEND                      @"FRIEND"
#define SPOUSE                      @"SPOUSE"
#define PARTNER                     @"PARTNER"
#define ASSISTANT                   @"ASSISTANT"
#define MANAGER                     @"MANAGER"
#define OTHER                       @"OTHER"

#define CUSTOM                       @"CUSTOM"
#define CUSTOM_ANDROID              @"X-"
//5.0
#define OTHERFAX                    @"OTHERFAX;"

#define SERVICEQQ                   @"SERVICEQQ:"
#define SERVICEGTALK                @"SERVICEGTALK:"
#define SERVICESKYPE                @"SERVICESKYPE:"
#define SERVICEFACEBOOK             @"SERVICEFACEBOOK:"
#define SERVICEGADUGADU             @"SERVICEGADUGADU:"


#define PROFILEPROPERTY             @"PROFILEPROPERTY"
#define PROFILEURLKEY               @"PROFILEURLKEY"
#define PROFILESERVICEKEY           @"PROFILESERVICEKEY"
#define PROFILEUSERNAMEKEY          @"PROFILEUSERNAMEKEY"
#define PROFILEUSERIDENTIFIERKEY    @"PROFILEUSERIDENTIFIERKEY"
#define SERVICETWITTER              @"SERVICETWITTER:"
#define SERVICEGAMECENTER           @"SERVICEGAMECENTER:"
#define SERVICEMYSPACE              @"SERVICEMYSPACE:"
#define SERVICELINKEDIN             @"SERVICELINKEDIN:"
#define SERVICEFLICKR               @"SERVICEFLICKR:"

//6.0
#define SERVICESINAWEIBO            @"SERVICESINAWEIBO:"

//2013_12_14
#define GROUPCODE       @"GROUPCODE"
#define IMAGEDATA       @"IMAGEDATA;"

#define ENDVCARD    @"END:VCARD"
#define VCARDFLAG   @"BEGIN:VCARD\r\nVERSION:2.1\r\nEND:VCARD\r\n"


#define LabelCategoryCell @"CELL"
#define LabelCategoryFax @"FAX"
#define LabelCategoryPager @"PAGER"
#define LabelCategoryIPhone @"X-iPhone"

#define LabelCategoryHome @"HOME"
#define LabelCategoryWork @"WORK"
#define LabelCategoryOther @"OTHER"
#define LabelCategoryMain  @"MAIN"
#define LabelCategoryAnniversary    @"ANNIVERSARY"
#define LabelCategoryOtherFAX       @"OtherFAX"

#endif /* ABConfigure_h */
