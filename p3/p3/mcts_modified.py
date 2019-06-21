
from mcts_node import MCTSNode
from random import choice
from math import sqrt, log

num_nodes = 100
explore_factor = 5
rollouts = 10
max_depth = 5

# helper function for traverse_nodes()
# returns the best leaf node
def UCT(node, isOpponent):
    best_node = choice(list(node.child_nodes.values()))
    max_value = 0
    for child in node.child_nodes.values():
        hrate = 0.5*child.visits
        hrate += -child.wins if isOpponent else child.wins
        value = hrate / child.visits + \
            ( explore_factor * \
            sqrt(log(node.visits/child.visits)) )
        if value > max_value:
            max_value = value
            best_node = child
    return best_node

def traverse_nodes(node, board, state, identity):
    """ Traverses the tree until the end criterion are met.

    Args:
        node:       A tree node from which the search is traversing.
        board:      The game setup.
        state:      The state of the game.
        identity:   The bot's identity, either 'red' or 'blue'.

    Returns:        A node from which the next stage of the search can proceed.

    """
    if node.untried_actions:
        return node, state
    elif not node.child_nodes:
        return node, state
    else:
        curr_id = board.current_player(state)
        best = UCT(node, 0 if curr_id==identity else 1)
        state = board.next_state(state, best.parent_action)
        return traverse_nodes(best, board, state, identity)
        


def expand_leaf(node, board, state):
    """ Adds a new leaf to the tree by creating a new child node for the given node.

    Args:
        node:   The node for which a child will be added.
        board:  The game setup.
        state:  The state of the game.

    Returns:    The added child node.

    """
    if not node.untried_actions:
        if not node.child_nodes:
            return node, state
        else:
            print("error: node was traversed to without untried actions, but with child nodes")
    random_move = choice(node.untried_actions)

    state = board.next_state(state, random_move)
    next_node = MCTSNode(parent=node, parent_action=random_move, action_list=board.legal_actions(state))
    
    # remove the move from list of untried moves
    node.untried_actions.remove(random_move)
    node.child_nodes[random_move] = next_node
    
    return next_node, state

def rollout(board, state, id):
    """ Given the state of the game, the rollout plays out the remainder randomly.

    Args:
        board:  The game setup.
        state:  The state of the game.

    """
    avg = 0
    for i in range(1, rollouts+1):
        sample = state
        for j in range(max_depth):
            if board.is_ended(sample):
                break
            random_move = choice(board.legal_actions(state))
            sample = board.next_state(sample, random_move)
        
        avg = avg*(i-1)/i+outcome(board, sample, id)*1/i
    
    return avg

def backpropagate(node, won):
    """ Navigates the tree from a leaf node to the root, updating the win and visit count of each node along the path.

    Args:
        node:   A leaf node.
        won:    An indicator of whether the bot won or lost the game.

    """
    while node != None:
        node.wins += won
        node.visits += 18
        node = node.parent
        
    return

def think(board, state):
    """ Performs MCTS by sampling games and calling the appropriate functions to construct the game tree.

    Args:
        board:  The game setup.
        state:  The state of the game.

    Returns:    The action to be taken.

    """
    identity_of_bot = board.current_player(state)
    root_node = MCTSNode(parent=None, parent_action=None, action_list=board.legal_actions(state))

    for step in range(num_nodes):
        # Copy the game for sampling a playthrough
        sampled_game = state

        # Start at root
        node = root_node

        # Do MCTS - This is all you!
        current_node, sampled_game = traverse_nodes(node, board, sampled_game, identity_of_bot)
    
        next_node, sampled_game = expand_leaf(current_node, board, sampled_game)
        
        h = rollout(board, sampled_game, identity_of_bot)

        backpropagate(next_node, h)

    next_node = choice(list(root_node.child_nodes.values()))
    max_winrate = 0

    for child in root_node.child_nodes.values():
        winrate = child.wins / child.visits
        if winrate > max_winrate:
            max_winrate = winrate
            next_node = child
    
    return next_node.parent_action
    
# Define a helper function to calculate the difference between the bot's score and the opponent's.
def outcome(board, state, me):
    game_points = board.points_values(state)
    owned_boxes = board.owned_boxes(state)
    if game_points is not None:
        # Try to normalize it up?  Not so sure about this code anyhow.
        red_score = game_points[1]*4.5
        blue_score = game_points[2]*4.5
    else:
        red_score = len([v for v in owned_boxes.values() if v == 1])
        blue_score = len([v for v in owned_boxes.values() if v == 2])
    return red_score - blue_score if me == 1 else blue_score - red_score
