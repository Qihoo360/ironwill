QHContacts
=======================
iOS平台上的通讯录转换为vCard2.1和将vCard2.1写入通讯录。
通过此SDK可以将手机通讯录转换为vCard字符串，以字符串形式保存通讯录，并可以将vCard格式的字符串写回到手机中，能够将vCard字符串与联系人比较，返回相同的联系人、相似的联系、增加和删除的联系人。 并提供清空联系人方法。

Requirement
===========
iOS6+

如何使用
=======================
QHContacts编译后是framework库，将framework库添加到工程中，在使用前包含头文件。
App端
---------------------------------

1) 引入头文件
```objc
#import "AddressBook.h"
```

2) 将通讯录生成vCard字符串
```objc
ABAddressBook *address = [[ABAddressBook alloc] initWithABRef:[ABAddressBook copyAddressBookCreate]];
NSString *str = [address vcardString];
```

3) 将vCard写回到通讯录
```objc
[ABAddressBook vcardStringToAddressBook:@“vCard格式串”];
```

4) 比较vCard字符串与本地通讯录变化
```objc
ABContactComparer *comparer = [ABContactComparer comparerWithVCard:self.vCardString];
    if (comparer && [comparer compare]) {
        NSString *msg = [NSString stringWithFormat:@"相同%ld，修改%ld，删除%ld，增加%ld"
                         ,[comparer.resultSame count],[comparer.resultSimilar count]
                         ,[comparer.resultLeft count],[comparer.resultRight count]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完成" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"本地通讯录为空，或vcard错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
```
5) 清空通讯录
```objc
[ABAddressBook cleanEmptyContacts:^(enumCleanState state) {
        if (CleanStateEnd == state) {
            NSLog(@"clear end");
        }
    }];
```
