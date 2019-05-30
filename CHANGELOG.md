## 1.0.0

- Initial version, created by Stagehand

## 1.2.0

fix: update can rebuild widget correctly.

- refactor：HookElement now extends from ~~ComponentElement~~StatelessElement
- refactor: HookWidget now extends from ~Widget~StatelessWidget

## 1.2.2

feature: useMemo receive a thunk to lazy compute.

## 1.2.3

feature: hotload will reset hook in Element.

## 1.2.4

fix: reassemble will clear effect.

# 1.2.5

feature: if you insert or remove a hook in your build method, frhooks will rerun the build method and drop the memorized state. 

# 1.2.6

fix: frhooks can rerun your hooks correctly after insert or remove one hook.
