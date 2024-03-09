# TreeSpeak

⚠️ CAUTION: Work in progress. This plugin is missing core features and is not usable in its current state ⚠️

TreeSpeak is a dialogue graph plugin and editor for Godot 4. 

Created by Scanian Forest.

![alt text](media/image.png)

## Features

* Branching dialogues using GraphNodes and connections
* Affect the game world using DialogueEvents (add/remove items, receive/complete quests)

## Architectural overview

This sections outlines how the plugin is designed.

```mermaid
classDiagram
namespace Godot {
	class GraphNode
	class GraphEdit
	class Resource
}
namespace Editor {
	class TreeSpeakGraph
	class DialogueNode {
		<<abstract>>
		deleted: signal
		position_updated: signal
		resource: Resource
		set_resource() abstract void
	}
	class DialoguePlayerNode {
		slot_removed: signal
		dialogue_option: DialogueOption
		_option_index: int
		_set_options(options: Array~String~)
	}
	class DialogueNpcNode
	class DialogueEventNode
}

namespace Model {
	class DialogueGraphResource {
		nodes: Dictionary~StringName,Resource~
		positions: Dictionary~StringName,Vector2~ 
		connections: Dictionary
	}
	class DialoguePlayerNodeResource { 
		+ options~String~ 
	}
	class DialogueNpcNodeResource { 
		+ line: String 
	}
	class DialogueEventNodeResource {
		+ event_name: String 
	}
}

namespace Controller {
	class DialogueManager {
		dialogue_updated: signal
		dialogue_closed: signal
		graph: DialogueGraphResource
	}	
}

DialogueGraphResource o-- Resource
DialoguePlayerNodeResource --|> Resource
DialogueNpcNodeResource --|> Resource
DialogueEventNodeResource --|> Resource

DialoguePlayerNode --|> DialogueNode
DialogueNpcNode --|> DialogueNode
DialogueEventNode --|> DialogueNode
DialogueNode --|> GraphNode
TreeSpeakGraph o-- DialogueNode
TreeSpeakGraph --|> GraphEdit
```


## Roadmap

This plugin will feature the following:

* A custom in-engine editor for designing dialogues
* A DialogueManager singleton to start dialogues using files (JSON) created in the custom editor.
* A DialogueChannel singleton, exposing signals so that your game systems can listen to and react to dialogue events.
* A basic UI framework to display the dialogues in-game
  * NPC and player portraits
  * Scrolling text
  * Selectable dialogue options


## Attributions

Plugin icon [Solid leaf](https://game-icons.net/1x1/delapouite/solid-leaf.html) created by [Delapouite](https://delapouite.com/) under [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/)
