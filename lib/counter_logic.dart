/// Команда для зміни стану лічильника.
///
/// Логіка відокремлена від UI, щоб її можна було тестувати окремо.
sealed class CounterCommand {
  const CounterCommand();
}

/// Додати [value] до поточного значення лічильника.
class AddCommand extends CounterCommand {
  const AddCommand(this.value);

  final int value;
}

/// Скинути лічильник до нуля.
class ResetCommand extends CounterCommand {
  const ResetCommand();
}

/// Невалідне введення — лічильник не змінюється.
class InvalidCommand extends CounterCommand {
  const InvalidCommand(this.message);

  final String message;
}

/// Термінальна команда для обнулення лічильника.
const String resetPhrase = 'Avada Kedavra';

/// Максимальне за модулем число, яке можна ввести за один раз.
const int maxInputMagnitude = 1000000;

/// Ціле число: необов'язковий знак і лише цифри.
/// Відсікає дробові числа, пробіли всередині, hex-формат (0x10) тощо.
final RegExp _integerPattern = RegExp(r'^[+-]?\d+$');

/// Перетворює введений рядок на команду для лічильника.
CounterCommand parseInput(String rawInput) {
  final input = rawInput.trim();

  if (input.isEmpty) {
    return const InvalidCommand('Поле не може бути порожнім');
  }

  if (input == resetPhrase) {
    return const ResetCommand();
  }

  // Синтаксичний контроль: чи це взагалі ціле число.
  if (!_integerPattern.hasMatch(input)) {
    return InvalidCommand('«$input» не є цілим числом');
  }

  // Логічний контроль: число має бути в допустимих межах.
  final value = int.tryParse(input);
  if (value == null || value.abs() > maxInputMagnitude) {
    return const InvalidCommand(
      'Число має бути в межах від -$maxInputMagnitude до $maxInputMagnitude',
    );
  }

  if (value == 0) {
    return const InvalidCommand('Додавання нуля нічого не змінить');
  }

  return AddCommand(value);
}
