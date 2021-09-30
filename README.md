# ReflexGame

Reflex Game
In this assignment project, you’ll find a simple game used to help people improve their reflexes. The game will test how long a user can follow the app as it flashes squares on a grid with increasing speed.
The app will have a single screen, which is the game screen with the following mock-up:

Mock-up | Itens description
------------ | ------------ 
<img width="217" alt="Captura de Tela 2021-09-26 às 18 46 06" src="https://user-images.githubusercontent.com/4182255/134825259-5aff0c33-018d-4be3-8951-face40ed8c47.png"> | (1) A 4x4 grid with a flashed square<br>(2) Time elapsed since the game started<br>(3) Start button<br>(4) Point counter

The user starts with 1 point, and the game goes as follows:
1. A random square is flashed (turned on and off) for T milliseconds
2. The app then waits T milliseconds - If the user tapped on the same square during
this time, their score is incremented by 1. If they tapped anywhere else or not at
all, it’s decremented by 1.
3. If the user’s score is 0, the game ends. Otherwise, it continues.
T will start at 3000 milliseconds, and multiply itself by 0.9 every 5 turns.

**On ReflexGameSequencial target this game flashs n squares in series instead of just 1**
