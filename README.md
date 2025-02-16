**Meteor Shower Game - IST 2021/22**

This repository contains the implementation of the **Meteor Shower Game**, a project developed for the **Introduction to Computer Architecture** course at Instituto Superior Técnico (IST). The game is developed in **assembly language** and runs on a simulated architecture using the PEPE processor.

## **Project Overview**

### **1. Game Concept**
- The player controls a **rover** defending **Planet X** from incoming meteor showers.
- The rover collects energy from **good meteors** (green) and destroys **enemy ships** (red meteors).
- The objective is to survive as long as possible by avoiding enemy collisions and managing energy levels.

### **2. Controls & Gameplay**
- **Start Game**: Press `C`
- **Move Rover Left/Right**: `0` (left), `2` (right)
- **Fire Missile**: `1`
- **Pause Game**: `B`
- **Resume Game**: `C`

### **3. Features Implemented**
- **Meteor and Enemy Ship Mechanics**:
  - Objects fall from the top of the screen, appearing small and increasing in size as they approach.
  - The player must distinguish between good meteors and enemy ships.
- **Collision and Energy System**:
  - Destroying enemy ships restores energy.
  - Collecting good meteors increases energy.
  - Firing missiles consumes energy.
  - The game ends if the rover collides with an enemy or runs out of energy.
- **Graphical Display**:
  - Objects are rendered in a **32x64 pixel** screen using **ARGB color encoding**.
  - Different background scenes for game states (playing, paused, game over).
- **Sound Effects**:
  - Explosion sounds for destroyed meteors and enemy ships.
  - Background music during gameplay.

### **4. Limitations & Known Issues**
- Only a **single enemy ship and meteor** are handled at a time.
- Restarting the game after finishing sometimes skips initial frames.
- Future improvements include adding **multiple meteor objects** and refining collision detection.

## **Installation & Setup**

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/meteor-shower-game.git
   cd meteor-shower-game
   ```

2. **Run the Game in the Simulator**
   - Load the `projeto.cir` circuit file into the PEPE simulator.
   - Assemble and load the `grupo39.asm` file.
   - Run the simulation and start playing!

## **Results Summary**
- Successfully implemented **game mechanics, collision handling, and energy system**.
- Basic **sound effects and graphics rendering** completed.
- Issues with game restarting and handling multiple meteors remain.



