/// Module: `formatter::formatter`
///
/// Provides a simple yet flexible string formatting utility for Move programs. It supports:
/// - Placeholder-based template formatting (`{}` replacement)
/// - Builder-style formatting using the `Formatter` struct for composing strings from various data types
/// - Convenience macros and methods to add numbers, addresses, booleans, and more.
module formatter::formatter;

use std::string::{Self, String};
use std::macros;
use std::debug;
use std::bcs;
use sui::hex;

/// Struct: `Formatter`
///
/// A builder-pattern string composer that allows appending values of different types
/// (strings, numbers, booleans, addresses, etc.) and later converting them into a single string.

public struct Formatter has drop {
    parts: vector<String>
}

/// Formats a template string by replacing `{}` placeholders with the given `values`.
///
/// Each `{}` in the `template` is replaced in order by the corresponding string from `values`.
/// If there are more placeholders than values, remaining `{}` are left untouched.
///
/// # Example:
/// ```
/// let template = "Hello {}, you have {} points";
/// let values = ["Alice", "42"];
/// let result = format_template(template, values);
/// // result: "Hello Alice, you have 42 points"
/// ```
public fun format_template(
    template: String,
    values: vector<String>
): String {
    let mut result = template;
    let mut i = 0;
    
    while (i < values.length()) {
        // Find and replace first occurrence of {}
        let result_bytes = result.as_bytes();
        let mut found_pos = option::none<u64>();
        
        let mut j = 0;
        while (j < result_bytes.length() - 1) {
            if (result_bytes[j] == 123 && result_bytes[j + 1] == 125) { // '{' = 123, '}' = 125
                found_pos = option::some(j);
                break
            };
            j = j + 1;
        };
        
        if (found_pos.is_some()) {
            let pos = found_pos.extract();
            
            let mut left = vector::empty<u8>();
            let mut right = vector::empty<u8>();
            
            let mut k = 0;
            while (k < pos) {
                left.push_back(result_bytes[k]);
                k = k + 1;
            };
            
            k = pos + 2;
            while (k < result_bytes.length()) {
                right.push_back(result_bytes[k]);
                k = k + 1;
            };
            
            vector::append(&mut left, *values[i].as_bytes());
            vector::append(&mut left, right);
            
            result = string::utf8(left);
        };
        i = i + 1;
    };
    
    result
}

/// Creates a new, empty `Formatter`.
///
/// # Example:
/// ```
/// let f = new_formatter();
/// ```
public fun new_formatter(): Formatter {
    Formatter { parts: vector::empty() }
}

/// Appends a plain string to the formatter.
public fun add_string(mut self: Formatter, text: String): Formatter {
    self.parts.push_back(text);
    self
}

/// Appends a `u128` value as string to the formatter.
public fun add_128(mut self: Formatter, value: u128): Formatter {
    self.parts.push_back(macros::num_to_string!(value));
    self
}

/// Appends a `u256` value as string to the formatter.
public fun add_u256(mut self: Formatter, value: u256): Formatter {
    self.parts.push_back(macros::num_to_string!(value));
    self
}

/// Appends a `u64` value as string to the formatter.
public fun add_u64(mut self: Formatter, value: u64): Formatter {
    self.parts.push_back(macros::num_to_string!(value));
    self
}

/// Appends a `u32` value as string to the formatter.
public fun add_u32(mut self: Formatter, value: u32): Formatter {
    self.parts.push_back(macros::num_to_string!(value));
    self
}

/// Appends a `u8` value as string to the formatter.
public fun add_u8(mut self: Formatter, value: u8): Formatter {
    self.parts.push_back(macros::num_to_string!(value));
    self
}

/// Macro: `add_number`
///
/// Generic macro to add any numeric type to the formatter (e.g., `u8`, `u64`, `u128`, `u256`, etc.).
///
/// # Example:
/// ```
/// f = f.add_number!(123u64);
/// ```
public macro fun add_number($self: Formatter, $value: _): Formatter {
    let mut self = $self;
    self.parts.push_back(macros::num_to_string!($value));
    self
}

/// Appends a boolean value (`true`/`false`) to the formatter.
public fun add_bool(mut self: Formatter, value: bool): Formatter {
    let text = if (value) { b"true".to_string() } else { b"false".to_string() };
    self.parts.push_back(text);
    self
}

/// Appends a `vector<u8>` (raw byte data) as string to the formatter.
/// Note: Data is not hex-encoded, just converted as-is.
public fun add_bytes(mut self: Formatter, value: vector<u8>): Formatter {
    self.parts.push_back(value.to_string());
    self
}

/// Appends an address to the formatter in standard `0x` hexadecimal format.
public fun add_address(mut self: Formatter, value: address): Formatter {
    let addr_bytes = bcs::to_bytes(&value);
    let hex_string = hex::encode(addr_bytes);
    self.parts.push_back(string::utf8(b"0x"));
    self.parts.push_back(string::utf8(hex_string));
    self
}

/// Finalizes the formatter and concatenates all parts into a single `String`.
///
/// # Example:
/// ```
/// let result = formatter.build();
/// ```
public fun build(self: Formatter): String {
    let mut result = string::utf8(b"");
    let mut i = 0;
    while (i < self.parts.length()) {
        result.append(self.parts[i]);
        i = i + 1;
    };
    result
}

/// Demonstrates manual formatting using string append operations and numeric macros.
///
/// This is a simple example, useful for quick format tasks without using `Formatter`.
///
/// # Output:
/// "User 123 has 45 points and balance 1000"
public fun format_simple(): String {
    let mut result = string::utf8(b"User ");
    result.append(macros::num_to_string!(123u64));
    result.append(string::utf8(b" has "));
    result.append(macros::num_to_string!(45u8));
    result.append(string::utf8(b" points and balance "));
    result.append(macros::num_to_string!(1000u32));
    result
}

/// Example usage functions
public fun example_simple() {
    let result = format_simple();
    debug::print(&result);
    // Result: "User 123 has 45 points and balance 1000"
}

/// Test: Example usage of `format_template`
///
/// Replaces `{}` placeholders in a template with values like name, points, and balance.
#[test]
fun example_template() {
    let template = string::utf8(b"Hello {}, you have {} points and {} balance");
    let mut values = vector[];
    values.push_back(string::utf8(b"Alice"));
    values.push_back(macros::num_to_string!(100u64));
    
    let result = format_template(template, values);
    debug::print(&result);
    // Result: "Hello Alice, you have 100 points and 500 balance"
}

/// Test: Example usage of the `Formatter` builder
///
/// Demonstrates chaining of `add_*` methods and macro for building a complex formatted string.

#[test]
fun example_builder() {
    let addr = @0x1234567890abcdef;
    let result = new_formatter()
        .add_string(b"User ID: ".to_string())
        .add_number!(12345u64)  // Using generic add_number macro
        .add_string(b", Address: ".to_string())
        .add_address(addr)
        .add_bytes(b", Active: ")
        .add_bool(true)
        .add_string(b", Score: ".to_string())
        .add_u32(9876u32)   // Works with any numeric type
        .add_string(b", Level: ".to_string())
        .add_number!(255u8)     // Works with u8 too
        .build();
    
    debug::print(&result);
    // Result: "User ID: 12345, Address: 0x1234567890abcdef, Active: true, Score: 9876, Level: 255"
}