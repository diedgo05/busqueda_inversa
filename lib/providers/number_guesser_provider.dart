import 'package:flutter/material.dart';

class GameState {
  final int minValue;
  final int maxValue;
  final int currentGuess;
  final int attemptCount;
  final bool gameOver;
  final bool gameWon;
  final List<String> history;

  GameState({
    required this.minValue,
    required this.maxValue,
    required this.currentGuess,
    required this.attemptCount,
    required this.gameOver,
    required this.gameWon,
    required this.history,
  });

  GameState copyWith({
    int? minValue,
    int? maxValue,
    int? currentGuess,
    int? attemptCount,
    bool? gameOver,
    bool? gameWon,
    List<String>? history,
  }) {
    return GameState(
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      currentGuess: currentGuess ?? this.currentGuess,
      attemptCount: attemptCount ?? this.attemptCount,
      gameOver: gameOver ?? this.gameOver,
      gameWon: gameWon ?? this.gameWon,
      history: history ?? this.history,
    );
  }
}

class NumberGuesserProvider extends ChangeNotifier {
  static const int maxAttempts = 7;
  static const int minNumber = 1;
  static const int maxNumber = 100;

  late GameState _state;

  GameState get state => _state;
  int get attemptsRemaining => maxAttempts - _state.attemptCount;
  double get progressPercentage => (_state.attemptCount / maxAttempts) * 100;

  NumberGuesserProvider() {
    _initializeGame();
  }

  void _initializeGame() {
    _state = GameState(
      minValue: minNumber,
      maxValue: maxNumber,
      currentGuess: _calculateMidpoint(minNumber, maxNumber),
      attemptCount: 0,
      gameOver: false,
      gameWon: false,
      history: [],
    );
  }

  int _calculateMidpoint(int min, int max) {
    return ((min + max) / 2).round();
  }

  void onNumberIsHigher() {
    if (_state.gameOver) return;

    int newMin = _state.currentGuess + 1;
    int newAttempt = _state.attemptCount + 1;
    List<String> newHistory = [
      ..._state.history,
      'Intento ${newAttempt}: Dije ${_state.currentGuess} - ¡Es MAYOR!'
    ];

    if (newAttempt >= maxAttempts) {
      _state = _state.copyWith(
        minValue: newMin,
        attemptCount: newAttempt,
        gameOver: true,
        history: newHistory,
      );
    } else {
      int newGuess = _calculateMidpoint(newMin, _state.maxValue);
      _state = _state.copyWith(
        minValue: newMin,
        currentGuess: newGuess,
        attemptCount: newAttempt,
        history: newHistory,
      );
    }

    notifyListeners();
  }

  void onNumberIsLower() {
    if (_state.gameOver) return;

    int newMax = _state.currentGuess - 1;
    int newAttempt = _state.attemptCount + 1;
    List<String> newHistory = [
      ..._state.history,
      'Intento ${newAttempt}: Dije ${_state.currentGuess} - ¡Es MENOR!'
    ];

    if (newAttempt >= maxAttempts) {
      _state = _state.copyWith(
        maxValue: newMax,
        attemptCount: newAttempt,
        gameOver: true,
        history: newHistory,
      );
    } else {
      int newGuess = _calculateMidpoint(_state.minValue, newMax);
      _state = _state.copyWith(
        maxValue: newMax,
        currentGuess: newGuess,
        attemptCount: newAttempt,
        history: newHistory,
      );
    }

    notifyListeners();
  }

  void onCorrectGuess() {
    if (_state.gameOver) return;

    int newAttempt = _state.attemptCount + 1;
    List<String> newHistory = [
      ..._state.history,
      'Intento ${newAttempt}: ¡ACERTÉ! El número era ${_state.currentGuess}'
    ];

    _state = _state.copyWith(
      attemptCount: newAttempt,
      gameOver: true,
      gameWon: true,
      history: newHistory,
    );

    notifyListeners();
  }

  void resetGame() {
    _initializeGame();
    notifyListeners();
  }
}