class com.xeio.EmpowermentHelper.Utils
{
	public static function Contains(array:Array, target):Boolean
	{
		for (var i:Number = 0 ; i < array.length ; i++)
		{
			if (array[i] == target)
			{
				return true;
			}
		}
		
		return false;
	}
    
    public static function Any(array:Array, func:Function):Boolean
	{
		for (var i:Number = 0 ; i < array.length ; i++)
		{
			if (func(array[i]))
			{
				return true;
			}
		}
		
		return false;
	}
	
}