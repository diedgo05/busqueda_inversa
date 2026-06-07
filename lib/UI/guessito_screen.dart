import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/number_guesser_provider.dart';

class GuessitoScreen extends StatelessWidget {
  const GuessitoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¡Adivina mi Número!'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF6366F1),
      ),
      body: Consumer<NumberGuesserProvider>(
        builder: (context, provider, _) {
          final state = provider.state;

          if (!state.gameOver) {
            return _buildGamePlay(context, provider);
          } else if (state.gameWon) {
            return _buildWinScreen(context, provider);
          } else {
            return _buildLoseScreen(context, provider);
          }
        },
      ),
    );
  }

  Widget _buildGamePlay(BuildContext context, NumberGuesserProvider provider) {
    final state = provider.state;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: isMobile ? 20 : 40),
            _buildProgressIndicator(provider),
            SizedBox(height: isMobile ? 30 : 50),
            _buildGuessCard(state.currentGuess, isMobile),
            SizedBox(height: isMobile ? 30 : 50),
            _buildInstructionText(isMobile),
            SizedBox(height: isMobile ? 30 : 40),
            _buildButtonGrid(context, provider, isMobile),
            SizedBox(height: isMobile ? 30 : 40),
            _buildHistorySection(state, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(NumberGuesserProvider provider) {
    return Column(
      children: [
        Text(
          'Intentos: ${provider.state.attemptCount}/${NumberGuesserProvider.maxAttempts}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: provider.progressPercentage / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              provider.progressPercentage > 70
                  ? Colors.orange
                  : const Color(0xFF6366F1),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Quedan ${provider.attemptsRemaining} intentos',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildGuessCard(int guess, bool isMobile) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF6366F1),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 32 : 48,
          horizontal: isMobile ? 24 : 40,
        ),
        child: Column(
          children: [
            Text(
              'Estoy pensando en...',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$guess',
              style: TextStyle(
                fontSize: isMobile ? 64 : 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionText(bool isMobile) {
    return Text(
      '¿Es correcto este número?',
      style: TextStyle(
        fontSize: isMobile ? 16 : 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtonGrid(
      BuildContext context, NumberGuesserProvider provider, bool isMobile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildRespondeButton(
                label: '⬆️ Mayor',
                onPressed: () => provider.onNumberIsHigher(),
                color: Colors.blue,
                isMobile: isMobile,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRespondeButton(
                label: '✓ Correcto',
                onPressed: () => provider.onCorrectGuess(),
                color: Colors.green,
                isMobile: isMobile,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRespondeButton(
                label: '⬇️ Menor',
                onPressed: () => provider.onNumberIsLower(),
                color: Colors.red,
                isMobile: isMobile,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRespondeButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required bool isMobile,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isMobile ? 12 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHistorySection(GameState state, bool isMobile) {
    if (state.history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historial',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: state.history
                .map(
                  (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  entry,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 13,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildWinScreen(BuildContext context, NumberGuesserProvider provider) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 24),
            Text(
              '¡Lo hiciste! ',
              style: TextStyle(
                fontSize: isMobile ? 28 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Adiviné tu número en ${provider.state.attemptCount} intento${provider.state.attemptCount == 1 ? '' : 's'}',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildHistorySection(provider.state, isMobile),
            const SizedBox(height: 32),
            _buildResetButton(provider, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildLoseScreen(BuildContext context, NumberGuesserProvider provider) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.highlight_off,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: 24),
            Text(
              'Se acabaron los intentos 😅',
              style: TextStyle(
                fontSize: isMobile ? 26 : 30,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Usaste ${provider.state.attemptCount} intentos. El número estaba entre ${provider.state.minValue} y ${provider.state.maxValue}',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildHistorySection(provider.state, isMobile),
            const SizedBox(height: 32),
            _buildResetButton(provider, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(NumberGuesserProvider provider, bool isMobile) {
    return ElevatedButton.icon(
      onPressed: () => provider.resetGame(),
      icon: const Icon(Icons.refresh),
      label: const Text('Jugar de Nuevo'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6366F1),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 32,
          vertical: isMobile ? 12 : 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}