// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PacmanGame {
    address public player;
    uint public score;

    enum Direction { UP, DOWN, LEFT, RIGHT }

    struct Position {
        uint x;
        uint y;
    }

    Position public pacman;
    Position public ghost;

    bool public gameOver;

    uint constant public gridSize = 10;
    uint constant public foodReward = 10;

    uint[][] public foodGrid;

    constructor() {
        player = msg.sender;
        resetGame();
    }

    function resetGame() internal {
        pacman = Position(0, 0);
        ghost = Position(5, 5);
        score = 0;
        gameOver = false;

        initializeFood();
    }

    function initializeFood() internal {
        // Инициализация сетки еды
        foodGrid = new uint[][](gridSize);
        for (uint i = 0; i < gridSize; i++) {
            foodGrid[i] = new uint[](gridSize);
            for (uint j = 0; j < gridSize; j++) {
                foodGrid[i][j] = 1; // 1 - еда доступна, 0 - еда съедена
            }
        }
    }

    function movePacman(Direction _direction) public {
        require(!gameOver, "Game over");

        // Логика движения Пакмана
        if (_direction == Direction.UP && pacman.y > 0) {
            pacman.y--;
        } else if (_direction == Direction.DOWN && pacman.y < gridSize - 1) {
            pacman.y++;
        } else if (_direction == Direction.LEFT && pacman.x > 0) {
            pacman.x--;
        } else if (_direction == Direction.RIGHT && pacman.x < gridSize - 1) {
            pacman.x++;
        }

        // Проверка на столкновение с призраком
        if (pacman.x == ghost.x && pacman.y == ghost.y) {
            gameOver = true;
        }

        // Проверка на сбор еды
        if (foodGrid[pacman.x][pacman.y] == 1) {
            score += foodReward;
            foodGrid[pacman.x][pacman.y] = 0; // Помечаем еду как съеденную
        }

        // Обновление счета
        score += 1;

        // Перемещение призрака
        moveGhost();

        // Проверка на окончание игры
        checkGameOver();
    }

    function moveGhost() internal {
        // Логика движения призрака
        // В данном примере призрак просто двигается в сторону Пакмана
        if (pacman.x > ghost.x) {
            ghost.x++;
        } else if (pacman.x < ghost.x) {
            ghost.x--;
        }

        if (pacman.y > ghost.y) {
            ghost.y++;
        } else if (pacman.y < ghost.y) {
            ghost.y--;
        }
    }

    function checkGameOver() internal {
        // Проверка на окончание игры (может быть основана на различных условиях)
        // В данном примере игра завершается, если все единицы на сетке еды съедены
        gameOver = true;
        for (uint i = 0; i < gridSize; i++) {
            for (uint j = 0; j < gridSize; j++) {
                if (foodGrid[i][j] == 1) {
                    gameOver = false;
                    return;
                }
            }
        }
    }
}
