# 🧰 Sui String Formatter

A lightweight string formatting module for the [Sui Move](https://docs.sui.io/) language, supporting both template-based formatting (like `{}` placeholders) and builder-style formatting using a `Formatter` struct.

## ✨ Features

* **Template Formatting**
  Format strings using placeholders `{}` and a vector of `String` arguments.

* **Builder-style Formatting**
  Compose strings by chaining `.add_*()` methods on a `Formatter` struct.

* **Supports Common Types**

  * `u64`, `bool`, `address`, `String`, `vector<u8>`

* **Escaping**
  Use `{{` and `}}` to escape literal braces.

## 🧪 Example Usage

### 1. Template-based Formatting

```move
use my_formatter::format_template;
use sui::string;

let name = string::utf8("Alice");
let age = string::utf8("30");

let args = vector[name, age];
let result = format_template("My name is {} and I am {} years old.", args);
// => "My name is Alice and I am 30 years old."
```

### 2. Builder-style Formatting

```move
use my_formatter::{Formatter, new};

let f = new_formatter()
    .add_str("Balance: ")
    .add_u64(1000)
    .add_str(" SUI");

let result = f.result();
// => "Balance: 1000 SUI"
```

## 📦 Module Structure

* `format_template(template: &String, args: vector<String>): String`
* `Formatter` struct

  * `.add_u64(val: u64): &Self`
  * `.add_bool(val: bool): &Self`
  * `.add_str(val: &String): &Self`
  * `.add_address(val: address): &Self`
  * `.add_bytes(bytes: vector<u8>): &Self`
  * `.result(): String`

## 📚 Why This Module?

Sui Move lacks native string formatting utilities. This module fills that gap with:

* Familiar formatting style for developers
* Flexibility via the formatter builder
* Clean handling of types and placeholder substitution

## 🛠️ Integration

To use this module in your Move project:

1. Clone or add the module to your Move package.
2. Import functions or the `Formatter` struct.
3. Write clean and readable string formatting logic.

## 🔐 License

MIT