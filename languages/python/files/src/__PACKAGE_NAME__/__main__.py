from {{PACKAGE_NAME}}.greet import greet


def main() -> None:
    print(greet("{{PROJECT_NAME}}"))


if __name__ == "__main__":
    main()
