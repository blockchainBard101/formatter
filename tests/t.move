// module coin_flip::formatter;

// use std::ascii;
// use std::bcs;
// use std::debug;
// use std::string::{Self, String};
// use std::u64;
// use std::u8;
// use std::vector;
// use std::macros;

// /// Format a string by replacing `{}` placeholders with args in order
// // public fun format_dynamic(fmt: &vector<u8>, args: vector<string::String>): string::String {
// //     let mut output = string::utf8(vector::empty());
// //     let mut i = 0;
// //     let mut arg_index = 0;

// //     while (i < vector::length(fmt)) {
// //         // Check if current and next character form a "{}"
// //         if (
// //             i + 1 < vector::length(fmt)
// //                 && *vector::borrow(fmt, i) == 123 /* '{' */
// //                 && *vector::borrow(fmt, i + 1) == 125 /* '}' */
// //         ) {
// //             if (arg_index < vector::length(&args)) {
// //                 output.append(*vector::borrow(&args, arg_index));
// //                 arg_index = arg_index + 1;
// //             } else {
// //                 // Optional: Add empty string or panic
// //                 output.append(string::utf8(b"<missing>"));
// //             };
// //             i = i + 2;
// //         } else {
// //             // Add literal character
// //             let ch = *vector::borrow(fmt, i);
// //             string::append_utf8(&mut output, vector::singleton(ch));
// //             i = i + 1;
// //         }
// //     };
// //     output
// // }

// // public fun format_bytes(fmt: &vector<u8>, args: vector<vector<u8>>): string::String {
// //     let mut output = string::utf8(vector::empty());
// //     let mut i = 0;
// //     let mut arg_index = 0;

// //     while (i < vector::length(fmt)) {
// //         if (
// //             i + 1 < vector::length(fmt)
// //                 && *vector::borrow(fmt, i) == 123 /* '{' */
// //                 && *vector::borrow(fmt, i + 1) == 125 /* '}' */
// //         ) {
// //             if (arg_index < vector::length(&args)) {
// //                 let arg = vector::borrow(&args, arg_index);
// //                 output.append(string::utf8(*arg));
// //                 arg_index = arg_index + 1;
// //             } else {
// //                 output.append(string::utf8(b"<missing>"));
// //             };
// //             i = i + 2;
// //         } else {
// //             let ch = *vector::borrow(fmt, i);
// //             string::append_utf8(&mut output, vector::singleton(ch));
// //             i = i + 1;
// //         }
// //     };
// //     output
// // }

// public enum FormatArg {
//     Str(string::String),
//     U64(u64),
//     Bool(bool),
// }

// fun append_arg(output: &mut string::String, arg: FormatArg) {
//     match (arg) {
//         FormatArg::Str(s) => output.append(s),
//         FormatArg::Bool(b) => {
//             let s = if (b) { string::utf8(b"true") } else { string::utf8(b"false") };
//             output.append(s)
//         },
//         FormatArg::U64(n) => {
//             let mut n_u8 = n.try_as_u8();
//             assert!(n_u8.is_some());
//             let s = n_u8.extract().to_string();
//             output.append(s)
//         },
//     }
// }

// // public fun format_advanced(fmt: &vector<u8>, args: vector<FormatArg>): string::String {
// //     let mut output = string::utf8(vector::empty());
// //     let mut i = 0;
// //     let mut arg_index = 0;

// //     while (i < vector::length(fmt)) {
// //         let ch = *vector::borrow(fmt, i);
// //         if (ch == 123 /* '{' */ ) {
// //             if (i + 1 < vector::length(fmt) && *vector::borrow(fmt, i + 1) == 123) {
// //                 // Escaped {{
// //                 string::append_utf8(&mut output, vector::singleton(123));
// //                 i = i + 2;
// //             } else if (i + 1 < vector::length(fmt) && *vector::borrow(fmt, i + 1) == 125) {
// //                 // `{}` placeholder
// //                 if (arg_index < vector::length(&args)) {
// //                     append_arg(&mut output, vector::borrow(&args, arg_index));
// //                     arg_index = arg_index + 1;
// //                     i = i + 2;
// //                 } else {
// //                     output.append(string::utf8(b"<missing>"));
// //                     i = i + 2;
// //                 }
// //             } else {
// //                 // Unrecognized '{'
// //                 string::append_utf8(&mut output, vector::singleton(ch));
// //                 i = i + 1;
// //             }
// //         } else if (
// //             ch == 125 /* '}' */ && i + 1 < vector::length(fmt) && *vector::borrow(fmt, i + 1) == 125
// //         ) {
// //             // Escaped }}
// //             string::append_utf8(&mut output, vector::singleton(125));
// //             i = i + 2;
// //         } else {
// //             string::append_utf8(&mut output, vector::singleton(ch));
// //             i = i + 1;
// //         }
// //     };
// //     output
// // }

// public fun u64_to_bytes(mut num: u64): vector<u8> {
//     if (num == 0) {
//         return b"0"
//     };
    
//     let mut digits = vector::empty<u8>();
    
//     while (num > 0) {
//         let digit = ((num % 10) as u8) + 48; // Convert to ASCII (48 = '0')
//         vector::push_back(&mut digits, digit);
//         num = num / 10;
//     };
    
//     vector::reverse(&mut digits);
//     digits
// }

// #[test]
// fun test_c() {
//     // let a = 65;
//     let a = 12345;
//     let mut message = b"my favourite number is ";
//     let number_bytes = u64_to_bytes(a);
    
//     // Append the readable number bytes to the message
//     vector::append(&mut message, number_bytes);
    
//     // This will print: "my favourite number is 12345"
//     debug::print(&string::utf8(message));

//     // let mut message = b"my favourite number is ";
//     // let number_bytes = bcs::to_bytes<u64>(&a);

//     // // Append the u64 bytes to the message
//     // vector::append(&mut message, number_bytes);


//     // let b: Option<u8> = u64::try_as_u8(a);

//     // let s = b"Hello {}";
//     // let args = vector::singleton(b"world");
//     // format_dynamic(&s, args);
//     // let out = format_bytes(&s, args);
//     // debug::print(&out);
// }

// module formatter::formatter_tests;
// // uncomment this line to import the module
// use formatter::formatter;
// use formatter::formatter::format_template;

// fun main() {
//     formatter::format_template(template, values);
// }