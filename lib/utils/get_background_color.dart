//Background colour
import 'package:flutter/material.dart';

(Color, String) getBackgroundColor(double temp) {
  if (temp < 20) {
    return (
      const Color(0xFFFF64D4),
      'Now it feels like +15°. It feels cool because of the rains. Today, the temperature is felt in the range from +20° to +15°.',
    );
  } else if (temp >= 20 && temp < 30) {
    return (
      const Color(0xFF42C6FF),
      'Now it feels like +25°. It feels humid now because of the heavy rain. Today, the temperature is felt in the range from +22° to +28°.',
    );
  } else {
    return (
      const Color(0xFFFFE142),
      'Now it feels like +30°. It feels hot because of the direct sun. Today, the temperature is felt in the range from +31° to +27°.',
    );
  }
}
