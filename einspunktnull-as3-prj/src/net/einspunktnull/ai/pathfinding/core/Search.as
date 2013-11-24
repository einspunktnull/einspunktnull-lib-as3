package net.einspunktnull.ai.pathfinding.core
{
	import net.einspunktnull.ai.pathfinding.data.Net;
	import net.einspunktnull.ai.pathfinding.data.Node;
	import net.einspunktnull.ai.pathfinding.data.NodeList;
	import net.einspunktnull.data.util.ArrayUtil;
	import net.einspunktnull.math.util.MathUtil;


	/**
	 * @author Albrecht Nitsche
	 */
	public class Search
	{
		private var nodes : Array;
		private var startNode : Node;
		private var endNode : Node;
		private var openList : NodeList = new NodeList();
		private var closedList : NodeList = new NodeList();
		private var shortestPath : Array = new Array();

		public function Search(net : Net)
		{
			this.nodes = net.nodes;
		}

		public function findPath(startNodeID : String, endNodeID : String) : Array
		{
			this.startNode = ArrayUtil.getElementsByProperty(nodes, "id", startNodeID)[0];
			this.endNode = ArrayUtil.getElementsByProperty(nodes, "id", endNodeID)[0];

			openList.clear();
			closedList.clear();
			while (shortestPath.length) shortestPath.pop();



			// alle Vorgänger löschen
			// Luftlinie von jedem Knoten zum Zielknoten
			for each (var node : Node in nodes)
			{
				node.pre = null;
				node.f = 0;
				node.g = 0;
				var dist : Number = MathUtil.distance(node, endNode);
				node.h = Math.round(dist);
			}

			// Initialisierung der Open List, die Closed List ist noch leer
			// (die Priorität bzw. der f Wert des Startknotens ist unerheblich)
			openList.add(startNode);

			// diese Schleife wird durchlaufen bis entweder
			// - die optimale Lösung gefunden wurde oder
			// - feststeht, dass keine Lösung existiert
			do
			{
				// Knoten mit dem geringsten f Wert aus der Open List entfernen
				var currentNode : Node = openList.removeMin();
				// Wurde das Ziel gefunden?
				if (currentNode == endNode)
				{
					return getResult();
				}
				// Wenn das Ziel noch nicht gefunden wurde: Nachfolgeknoten
				// des aktuellen Knotens auf die Open List setzen
				expandNode(currentNode);
				// der aktuelle Knoten ist nun abschließend untersucht
				closedList.add(currentNode);
			}
			while (!openList.isEmpty);
			// die Open List ist leer, es existiert kein Pfad zum Ziel
			return null;
		}

		// überprüft alle Nachfolgeknoten und fügt sie der Open List hinzu, wenn entweder
		// - der Nachfolgeknoten zum ersten Mal gefunden wird oder
		// - ein besserer Weg zu diesem Knoten gefunden wird
		private function expandNode(currentNode : Node) : void
		{
			for each (var successor : Node in currentNode.siblings)
			{
				// wenn der Nachfolgeknoten bereits auf der Closed List ist - tue nichts
				if (closedList.contains(successor)) continue;
				// g Wert für den neuen Weg berechnen: g Wert des Vorgängers plus
				// die Kosten der gerade benutzten Kante
				var dist : Number = MathUtil.distance(successor, currentNode);
				var tentative_g : Number = currentNode.g + dist;
				// wenn der Nachfolgeknoten bereits auf der Open List ist,
				// aber der neue Weg nicht besser ist als der alte - tue nichts
				if (openList.contains(successor) && tentative_g >= successor.g) continue;
				// Vorgängerzeiger setzen und g Wert merken
				successor.pre = currentNode;
				successor.g = tentative_g;
				// f Wert des Knotens in der Open List aktualisieren
				// bzw. Knoten mit f Wert in die Open List einfügen
				var f : Number = tentative_g + successor.h;
				if (openList.contains(successor)) successor.f = f;
				else
				{
					successor.f = f;
					openList.add(successor);
				}
			}
		}

		private function getResult() : Array
		{
			shortestPath.push(endNode);
			look(endNode);
			shortestPath.reverse();
			return shortestPath;
		}

		private function look(node : Node) : void
		{
			if (node.pre != null)
			{
				shortestPath.push(node.pre);
				look(node.pre);
			}
		}
	}
}
