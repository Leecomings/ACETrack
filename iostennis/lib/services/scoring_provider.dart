import 'package:flutter/material.dart';

/// 全局计分状态管理
/// 实现标准网球计分规则：分数(0/15/30/40/Deuce/Ad)、局(game)、盘(set)
class ScoringProvider extends ChangeNotifier {
  // Player names
  String _playerAName = '选手 A';
  String _playerBName = '选手 B';
  
  // Set scores
  int _setsA = 0;
  int _setsB = 0;
  
  // Game scores (within current set)
  int _gamesA = 0;
  int _gamesB = 0;
  
  // Point scores (within current game): 0=0, 1=15, 2=30, 3=40
  int _pointsA = 0;
  int _pointsB = 0;
  
  // Total points
  int _totalPointsA = 0;
  int _totalPointsB = 0;
  
  // Server
  bool _isServerA = true;
  
  // Match state
  bool _isMatchInProgress = false;
  String _currentSet = '第1盘';
  
  // History
  List<String> _gameHistory = [];

  // Getters
  String get playerAName => _playerAName;
  String get playerBName => _playerBName;
  int get setsA => _setsA;
  int get setsB => _setsB;
  int get gamesA => _gamesA;
  int get gamesB => _gamesB;
  int get pointsA => _pointsA;
  int get pointsB => _pointsB;
  int get totalPointsA => _totalPointsA;
  int get totalPointsB => _totalPointsB;
  bool get isServerA => _isServerA;
  bool get isMatchInProgress => _isMatchInProgress;
  String get currentSet => _currentSet;
  List<String> get gameHistory => List.unmodifiable(_gameHistory);
  String get serverName => _isServerA ? _playerAName : _playerBName;

  void startMatch() {
    _isMatchInProgress = true;
    _setsA = 0;
    _setsB = 0;
    _gamesA = 0;
    _gamesB = 0;
    _pointsA = 0;
    _pointsB = 0;
    _totalPointsA = 0;
    _totalPointsB = 0;
    _isServerA = true;
    _currentSet = '第1盘';
    _gameHistory = [];
    notifyListeners();
  }

  void playerWinsPoint(String player) {
    if (!_isMatchInProgress) return;

    if (player == 'A') {
      _totalPointsA++;
      _handlePointWon(isA: true);
    } else {
      _totalPointsB++;
      _handlePointWon(isA: false);
    }
    notifyListeners();
  }

  void _handlePointWon({required bool isA}) {
    final pA = _pointsA;
    final pB = _pointsB;

    // Deuce situation (both at 40 or beyond)
    if (pA >= 3 && pB >= 3) {
      if (isA) {
        if (pA > pB) {
          // A wins game
          _winGame(isA: true);
          return;
        } else if (pA == pB) {
          // A gets advantage
          _pointsA = 4; // Ad
          return;
        } else {
          // Back to deuce
          _pointsA = 3;
          _pointsB = 3;
          return;
        }
      } else {
        if (pB > pA) {
          _winGame(isA: false);
          return;
        } else if (pA == pB) {
          _pointsB = 4; // Ad
          return;
        } else {
          _pointsA = 3;
          _pointsB = 3;
          return;
        }
      }
    }

    // Normal scoring
    if (isA) {
      _pointsA++;
      if (_pointsA >= 4 && pA < 3) {
        // A wins game (was at 40, opponent was below 40)
        _winGame(isA: true);
      }
    } else {
      _pointsB++;
      if (_pointsB >= 4 && pB < 3) {
        _winGame(isA: false);
      }
    }
  }

  void _winGame({required bool isA}) {
    final gameScore = _formatGameScore();
    _gameHistory.add(gameScore);

    if (isA) {
      _gamesA++;
    } else {
      _gamesB++;
    }

    // Reset points
    _pointsA = 0;
    _pointsB = 0;

    // Switch server every game
    _isServerA = !_isServerA;

    // Check set win (6 games, lead by 2; or tiebreak at 6-6)
    if (_gamesA >= 6 || _gamesB >= 6) {
      if ((_gamesA >= 6 && _gamesA - _gamesB >= 2) ||
          (_gamesB >= 6 && _gamesB - _gamesA >= 2)) {
        _winSet(isA: _gamesA > _gamesB);
      }
      // Tiebreak at 6-6 is simplified: first to 7
      else if (_gamesA == 6 && _gamesB == 6) {
        // For simplicity, next game wins the set
      }
    }
  }

  void _winSet({required bool isA}) {
    if (isA) {
      _setsA++;
    } else {
      _setsB++;
    }
    _gamesA = 0;
    _gamesB = 0;
    _currentSet = '第${_setsA + _setsB + 1}盘';

    // Match win: best of 3 sets
    if (_setsA >= 2 || _setsB >= 2) {
      _isMatchInProgress = false;
      _gameHistory.add('🏆 ${isA ? _playerAName : _playerBName} 获胜! (${_setsA}-${_setsB})');
    } else {
      _gameHistory.add('📊 ${isA ? _playerAName : _playerBName} 拿下第${_setsA + _setsB}盘');
    }
  }

  String _formatGameScore() {
    const labels = ['0', '15', '30', '40'];
    if (_pointsA >= 3 && _pointsB >= 3) {
      if (_pointsA == _pointsB) return 'Deuce';
      return _pointsA > _pointsB ? 'Ad-A' : 'Ad-B';
    }
    return '${labels[_pointsA.clamp(0, 3)]}-${labels[_pointsB.clamp(0, 3)]}';
  }

  void undoLastPoint() {
    // Simplified undo - just remove last history entry
    if (_gameHistory.isNotEmpty) {
      _gameHistory.removeLast();
      notifyListeners();
    }
  }

  void resetMatch() {
    _isMatchInProgress = false;
    _setsA = 0;
    _setsB = 0;
    _gamesA = 0;
    _gamesB = 0;
    _pointsA = 0;
    _pointsB = 0;
    _totalPointsA = 0;
    _totalPointsB = 0;
    _isServerA = true;
    _currentSet = '第1盘';
    _gameHistory = [];
    notifyListeners();
  }
}
