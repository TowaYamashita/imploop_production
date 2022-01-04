- このディレクトリにはモデルとそのモデルで行える操作をまとめたクラスを配置する

```dart
class SampleUser{
    final String firstName;
    final String lastName;
    final String email;

    SampleUser(this.firstName, this.lastName, this.email,):assert(validate(firstName, lastName, email));

    static bool validate(firstName, lastName, email){
        final bool isValidfirstName = firstName.isNotEmpty && firstName.length < 30;
        final bool isValidLastName = lastName.isNotEmpty && lastName.length < 30;
        final bool isValidEmail = email.isNotEmpty;

        return (isValidfirstName && isValidLastName && isValidEmail);
    }

    String getFullName(){
        return ("${lastName} ${firstName}");
    }
}
```