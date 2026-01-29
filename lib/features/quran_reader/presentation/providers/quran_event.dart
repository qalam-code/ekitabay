abstract class QuranEvent {}

class LoadSurahEvent extends QuranEvent {
  final int surahNumber;
  LoadSurahEvent(this.surahNumber);
}

class UpdateAudioPositionEvent extends QuranEvent {
  final Duration position;
  UpdateAudioPositionEvent(this.position);
}

class TogglePlayPauseEvent extends QuranEvent {}
