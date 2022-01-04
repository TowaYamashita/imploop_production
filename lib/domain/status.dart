enum StatusProcess {
  todo,
  doing,
  done,
}

class Status {
  Status({
    required this.currentProcess,
  });
  final StatusProcess currentProcess;

  String getDisplayName() {
    switch (currentProcess) {
      case StatusProcess.todo:
        return 'これからやる';
      case StatusProcess.doing:
        return '今やってる';
      case StatusProcess.done:
        return 'もうやった';
    }
  }

  static int getStatusNumber(StatusProcess currentProcess){
    switch (currentProcess) {
      case StatusProcess.todo:
        return 1;
      case StatusProcess.doing:
        return 2;
      case StatusProcess.done:
        return 3;
    }
  }
}
