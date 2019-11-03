import 'package:aqueduct/managed_auth.dart';

import '../../aqueduct_base.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {

  @Column(unique: true)
  String phone;

  @Column(nullable: true)
  bool isMan;

  @Column(nullable: true)
  String nickName; //用户昵称

  @Column(nullable: true)

  String avatar; //头像
  DateTime createTime; //创建时间

  @Column(nullable: true)
  DateTime updateTime; //更新时间

  @Column(nullable: true)
  DateTime lastTime; //最后登录的时间

}
