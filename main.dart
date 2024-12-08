import 'dart:io';

enum BookStatus { available, borrowed }

class Book {
  String title;
  String author;
  String isbn;
  BookStatus status;

  Book(this.title, this.author, this.isbn, this.status) {
    if (!isValidISBN(isbn)) {
      throw ArgumentError('Invalid ISBN format.');
    }
  }

  bool isValidISBN(String isbn) {
    final isbnRegex = RegExp(r'^\d{9}$');
    return isbnRegex.hasMatch(isbn);
  }

  void updateStatus(BookStatus newStatus) {
    status = newStatus;
  }

  @override
  String toString() {
    return 'Title: $title, Author: $author, ISBN: $isbn, Status: ${status.name}';
  }
}

void main() {
  List<Book> bookCollection = [];

  void addBook() {
    try {
      print('Enter title:');
      String? title = stdin.readLineSync();
      print('Enter author:');
      String? author = stdin.readLineSync();
      print('Enter ISBN (please input 9 numbers):');
      String? isbn = stdin.readLineSync();
      print('Enter status (1 for available, 2 for borrowed):');
      String? statusInput = stdin.readLineSync();
      BookStatus status =
          statusInput == '1' ? BookStatus.available : BookStatus.borrowed;

      if (title != null && author != null && isbn != null) {
        Book book = Book(title, author, isbn, status);
        bookCollection.add(book);
        print('Book added successfully: $book');
      } else {
        print('Invalid input. Please try again.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void removeBook() {
    print('Enter ISBN of the book to remove:');
    String? isbn = stdin.readLineSync();
    if (isbn != null) {
      bookCollection.removeWhere((book) => book.isbn == isbn);
      print('Book with ISBN $isbn removed successfully!');
    } else {
      print('Invalid ISBN.');
    }
  }

  void updateBookStatus() {
    print('Enter ISBN of the book to update:');
    String? isbn = stdin.readLineSync();
    print('Enter new status (1 for available, 2 for borrowed):');
    String? statusInput = stdin.readLineSync();

    BookStatus? newStatus =
        statusInput == '1' ? BookStatus.available : BookStatus.borrowed;

    if (isbn != null) {
      for (var book in bookCollection) {
        if (book.isbn == isbn) {
          book.updateStatus(newStatus);
          print('Status of "${book.title}" updated to ${newStatus.name}.');
          return;
        }
      }
      print('Book with ISBN $isbn not found.');
    } else {
      print('Invalid input.');
    }
  }

  void searchByTitle() {
    print('Enter title to search:');
    String? title = stdin.readLineSync();
    if (title != null) {
      var results = bookCollection.where((book) => book.title.contains(title));
      if (results.isEmpty) {
        print('No books found with title containing "$title".');
      } else {
        results.forEach((book) => print(book));
      }
    }
  }

  void searchByAuthor() {
    print('Enter author to search:');
    String? author = stdin.readLineSync();
    if (author != null) {
      var results =
          bookCollection.where((book) => book.author.contains(author));
      if (results.isEmpty) {
        print('No books found by author "$author".');
      } else {
        results.forEach((book) => print(book));
      }
    }
  }

  void displayMenu() {
    print('\n--- Book Management System ---\n');
    print('1. Add a new book');
    print('2. Remove a book');
    print('3. Update book status');
    print('4. Search by title');
    print('5. Search by author');
    print('6. View all books');
    print('7. Exit');
    print('\nEnter your choice:');
  }

  void viewAllBooks() {
    if (bookCollection.isEmpty) {
      print('No books in the collection.');
    } else {
      print('\nBooks in the collection:');
      bookCollection.forEach((book) => print(book));
    }
  }

  while (true) {
    displayMenu();
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        addBook();
        break;
      case '2':
        removeBook();
        break;
      case '3':
        updateBookStatus();
        break;
      case '4':
        searchByTitle();
        break;
      case '5':
        searchByAuthor();
        break;
      case '6':
        viewAllBooks();
        break;
      case '7':
        print('Exiting program...');
        return;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}
