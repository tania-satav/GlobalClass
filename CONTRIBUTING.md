## Brief workflow to follow

## 1) Main branch rule
- main must always be stable and runnable.
- Do not push directly to main branch
- All code changes go through a Pull Request 

## 2) Branch naming

- create branches for everything, shouldnt be any code being directly pushed to main unless its something small like a typo in comment
- be specific with the branches, can make multiple stemming from one if needed for something like a big feature

Create branches from main using one of these prefixes for e.g

- `feature/<short-description>`
- `fix/<short-description>`
- `docs/<short-description>`

e.g
- `feature/plant-list`
- `feature/watering-log`
- `fix/crash-on-save`
- `docs/readme-update`

Use all lowercase with hyphens

## 3) Starting work
Before creating a branch:

git checkout main
git pull

- you are better off constanly pulling , makes no difference if nothing to pull but will cause a headache if new code    is  made and not pulled before starting new code yourself!!
## 4) when creating a branch 

git checkout -b feature/<name>


## 5) Commit rules: 
- Commit small, logical chunks, were better off commiting more than less. also easier to fix when something breaks
- specify exactly what you're commiting like what part of a feature, what bug did you fix etc.

## 6) 	Pull Request (PR) rules
A PR should:

- Have a clear title 
- Include a short description 
- Be small enough to review 
- dont include unrelated changes

Minimum checks before requesting review
- App runs on Android emulator and XCode for relevant devs
- no errors in vscode
- No obvious UI breakage/ bugs

## 7) Merging

- Delete the branch after merge if code is working fine!!!!

## 8) Avoiding conflicts

- Pull main frequently.
- Don’t keep branches open too long.

To re-sync your branch:

git fetch origin
git merge origin/main