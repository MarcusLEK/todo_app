import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/services/auth.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
      // this is done because MockUser has 2 instance.
      // MockUser() != MockUser()
    ]);
  }
}

// this unit test is just to test for single function in the application.
// try to avoid running redundant test such as testing firebase auth, as these are already tested by firebase themselves.


void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);
  setUp(() {});
  tearDown(() {});

  test("emit occurs", () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  test("create account", () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
        email: "mario@gmail.com",
        password: "test1234",
      ),
    ).thenAnswer((realInvocation) => null);


    expect(await auth.createAccount(email: "mario@gmail.com", password: "test1234"), "Success");
  });

  test("create account exception", () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
        email: "mario@gmail.com",
        password: "test1234",
      ),
    ).thenAnswer((realInvocation) => throw FirebaseAuthException(message: "You messed up"));


    expect(await auth.createAccount(email: "mario@gmail.com", password: "test1234"), "You messed up");
  });

  test("sign in", () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
        email: "mario@gmail.com",
        password: "test1234",
      ),
    ).thenAnswer((realInvocation) => null);


    expect(await auth.signIn(email: "mario@gmail.com", password: "test1234"), "Success");
  });

  test("sign in exception", () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
        email: "mario@gmail.com",
        password: "test1234",
      ),
    ).thenAnswer((realInvocation) => throw FirebaseAuthException(message: "You messed up"));


    expect(await auth.signIn(email: "mario@gmail.com", password: "test1234"), "You messed up");
  });

  test("sign out", () async {
    when(
      mockFirebaseAuth.signOut(),
    ).thenAnswer((realInvocation) => null);


    expect(await auth.signOut(), "Success");
  });

  test("sign out exception", () async {
    when(
      mockFirebaseAuth.signOut(),
    ).thenAnswer((realInvocation) => throw FirebaseAuthException(message: "You messed up"));


    expect(await auth.signOut(), "You messed up");
  });
}
