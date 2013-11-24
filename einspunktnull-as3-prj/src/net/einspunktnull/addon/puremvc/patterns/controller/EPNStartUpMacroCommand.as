package net.einspunktnull.addon.puremvc.patterns.controller
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;


	/**
	 * @author Albrecht Nitsche
	 */
	public class EPNStartUpMacroCommand extends MacroCommand
	{

		override protected function initializeMacroCommand() : void
		{
			addSubCommand(EPNSimpleCommand);
		}
	}
}
