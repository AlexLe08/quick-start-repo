from {{PACKAGE_NAME}}.greet import greet


def test_greets_by_name() -> None:
    assert greet("Alex") == "Hello, Alex!"
