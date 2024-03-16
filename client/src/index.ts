import { Game, Types } from 'phaser';
import { LoginScene, LobbyScene, TableInteractionScene } from './scenes';

// Game configuration
const gameConfig: Types.Core.GameConfig = {
  title: 'Phaser Game',
  type: Phaser.AUTO,
  parent: 'game-container',
  backgroundColor: '#ffffff',
  scale: {
    mode: Phaser.Scale.ScaleModes.RESIZE,
    width: window.innerWidth,
    height: window.innerHeight,
  },
  scene: [LoginScene, LobbyScene, TableInteractionScene],
};

// Initialize the game
const game = new Game(gameConfig);

