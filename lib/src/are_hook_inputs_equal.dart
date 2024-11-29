areHookInputsEqual(List? listA, List? listB) {
  if (listA == null || listB == null) {
    return false;
  }

  if (listA.length != listB.length) {
    return false;
  }

  for (int i = 0; i < listA.length; i++) {
    if (listA[i] != listB[i]) {
      return false;
    }
  }

  return true;
}
