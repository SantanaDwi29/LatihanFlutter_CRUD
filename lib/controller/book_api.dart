import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/book_model.dart';

const String apiUrl = "http://10.20.2.146/Flutter/";

class BookApi {
  static Future<bool> createBook(String title, String author, int year) async {
    try {
      final response = await http.post(
        Uri.parse('${apiUrl}Create.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'title': title, 'author': author, 'year': year.toString()},
      );

      if (response.statusCode == 200) {
        print('Book added successfully');
        return true;
      } else {
        print('Failed to add book: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error creating book: $e');
      return false;
    }
  }

  static Future<List<Book>> getBooks() async {
    try {
      final response = await http
          .get(
            Uri.parse('${apiUrl}Read.php'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(seconds: 10)); 

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<Book> books = [];

        if (response.body.isNotEmpty && response.body != 'null') {
          try {
            dynamic jsonData = json.decode(response.body);

            // Handle jika response adalah array
            if (jsonData is List) {
              List<dynamic> data = jsonData;
              for (var item in data) {
                books.add(Book.fromJson(item));
              }
            }
            else if (jsonData is Map && jsonData.containsKey('data')) {
              List<dynamic> data = jsonData['data'];
              for (var item in data) {
                books.add(Book.fromJson(item));
              }
            }
          } catch (e) {
            print('JSON parsing error: $e');
            throw Exception('Invalid JSON format from server');
          }
        }

        return books;
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout - Check your internet connection');
    } on SocketException {
      throw Exception('No internet connection - Check your network');
    } catch (e) {
      print('Error getting books: $e');
      if (e.toString().contains('XMLHttpRequest')) {
        throw Exception('Connection failed - Check server URL and CORS settings');
      }
      throw Exception('Failed to load books: $e');
    }
  }

  // UPDATE
  static Future<bool> updateBook(int id, String title, String author, int year) async {
    try {
      final response = await http.post(
        Uri.parse('${apiUrl}Update.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'id': id.toString(),
          'title': title,
          'author': author,
          'year': year.toString(),
        },
      );

      if (response.statusCode == 200) {
        print('Book updated successfully');
        return true;
      } else {
        print('Failed to update book: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating book: $e');
      return false;
    }
  }

  // DELETE
  static Future<bool> deleteBook(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${apiUrl}Delete.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'id': id.toString()},
      );

      if (response.statusCode == 200) {
        print('Book deleted successfully');
        return true;
      } else {
        print('Failed to delete book: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error deleting book: $e');
      return false;
    }
  }
}