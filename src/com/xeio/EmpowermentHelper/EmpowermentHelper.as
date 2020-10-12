import com.GameInterface.DistributedValueBase;
import com.GameInterface.Game.Character;
import com.GameInterface.Inventory;
import com.GameInterface.InventoryItem;
import com.GameInterface.Quests;
import com.Utils.Archive;
import com.Utils.ID32;
import com.Utils.LDBFormat;
import com.xeio.EmpowermentHelper.Utils;
import mx.utils.Delegate;

class EmpowermentHelper
{    
    private var m_swfRoot: MovieClip;

    private var m_inventory:Inventory;
    private var m_craftingInventory:Inventory

    private var EMPOWER_SLOT_0:Number = 3;
    private var EMPOWER_SLOT_1:Number = 4;
    private var EMPOWER_SLOT_2:Number = 5;
    private var EMPOWER_SLOT_3:Number = 6;
    private var EMPOWER_SLOT_4:Number = 7;

    private var WEAPON:Number = 30151;
    private var TALISMAN:Number = 30152;
    private var GLYPH:Number = 30153;
    private var SIGNET:Number = 30154;

    var m_glyphDistillateButton:MovieClip;
    var m_weaponDistillateButton:MovieClip;
    var m_signetDistillateButton:MovieClip;
    var m_talismanDistillateButton:MovieClip;
    var m_returnButton:MovieClip;

    var m_clipLoader:MovieClipLoader;

    public static function main(swfRoot:MovieClip):Void 
    {
        var empowermentHelper = new EmpowermentHelper(swfRoot);

        swfRoot.onLoad = function() { empowermentHelper.OnLoad(); };
        swfRoot.OnUnload = function() { empowermentHelper.OnUnload(); };
        swfRoot.OnModuleActivated = function(config:Archive) { empowermentHelper.Activate(config); };
        swfRoot.OnModuleDeactivated = function() { return empowermentHelper.Deactivate(); };
    }

    public function EmpowermentHelper(swfRoot: MovieClip) 
    {
        m_swfRoot = swfRoot;
    }

    public function OnUnload()
    {
        m_glyphDistillateButton.onPress = undefined;
        m_weaponDistillateButton.onPress = undefined;
        m_signetDistillateButton.onPress = undefined;
        m_talismanDistillateButton.onPress = undefined;
        m_returnButton.onPress = undefined;
        
        m_clipLoader.unloadClip(m_glyphDistillateButton);
        m_clipLoader.unloadClip(m_weaponDistillateButton);
        m_clipLoader.unloadClip(m_signetDistillateButton);
        m_clipLoader.unloadClip(m_talismanDistillateButton);
        m_clipLoader.unloadClip(m_returnButton);
        
        m_clipLoader.removeListener(this);
    }

    public function Activate(config: Archive)
    {
    }

    public function Deactivate(): Archive
    {
        var archive: Archive = new Archive();			
        return archive;
    }

    public function OnLoad()
    {        
        m_clipLoader = new MovieClipLoader();
        m_clipLoader.addListener(this);
        
        m_inventory = new Inventory(new com.Utils.ID32(_global.Enums.InvType.e_Type_GC_BackpackContainer, Character.GetClientCharID().GetInstance()));
        m_craftingInventory = new Inventory(new ID32(_global.Enums.InvType.e_Type_GC_CraftingInventory, Character.GetClientCharID().GetInstance()));
        
        Initialize();
    }
    
    static function MakeStringsIntoPrefixes(names:Array):Array
    {
        for (var i in names)
        {
            names[i] = names[i].substr(0, names[i].indexOf("(", 0));
        }
        return names;
    }

    public function Initialize()
    {
        AddUIButtons();
    }
    
    public function AddUIButtons()
    {
        var x:MovieClip = _root.itemupgrade.m_Window.m_Content.m_EmpowermentTab;
        
        if (!x) 
        {
            if (DistributedValueBase.GetDValue("ItemUpgradeWindow"))
            {
                setTimeout(Delegate.create(this, Initialize), 50);
            }
            return;
        }
        
        m_glyphDistillateButton = x.createEmptyMovieClip("u_m_glyphDistillateButton", x.getNextHighestDepth());
        m_clipLoader.loadClip("rdb:1000624:9286816", m_glyphDistillateButton);
        
        m_weaponDistillateButton = x.createEmptyMovieClip("u_m_weaponDistillateButton", x.getNextHighestDepth());
        m_clipLoader.loadClip("rdb:1000624:9286813", m_weaponDistillateButton);
        
        m_signetDistillateButton = x.createEmptyMovieClip("u_m_signetDistillateButton", x.getNextHighestDepth());
        m_clipLoader.loadClip("rdb:1000624:9286815", m_signetDistillateButton);
        
        m_talismanDistillateButton = x.createEmptyMovieClip("u_m_talismanDistillateButton", x.getNextHighestDepth());
        m_clipLoader.loadClip("rdb:1000624:9286814", m_talismanDistillateButton);
        
        m_returnButton = x.createEmptyMovieClip("u_m_returnButton", x.getNextHighestDepth());
        m_clipLoader.loadClip("rdb:1000624:9306661", m_returnButton);
    }
    
    function onLoadComplete(target:MovieClip)
    {
        var xOffset = -55;
        var yOffset = 40;
        var width = 40;
        var assembleButton = _root.itemupgrade.m_Window.m_Content.m_EmpowermentTab.m_AssembleButton;
        if (target == m_weaponDistillateButton)
        {
            m_weaponDistillateButton._x = assembleButton._x + xOffset;
            m_weaponDistillateButton._y = assembleButton._y + yOffset;
            m_weaponDistillateButton._width = width;
            m_weaponDistillateButton._height = width;
            
            m_weaponDistillateButton.onPress = Delegate.create(this, function(){ this.FindMatchingDistillates(this.WEAPON); } );
        }
        if (target == m_talismanDistillateButton)
        {
            m_talismanDistillateButton._x = assembleButton._x + xOffset + (width + 5);
            m_talismanDistillateButton._y = assembleButton._y + yOffset;
            m_talismanDistillateButton._width = width;
            m_talismanDistillateButton._height = width;
            
            m_talismanDistillateButton.onPress = Delegate.create(this, function(){ this.FindMatchingDistillates(this.TALISMAN); } );
        }
        if (target == m_glyphDistillateButton)
        {
            m_glyphDistillateButton._x = assembleButton._x + xOffset + (width + 5) * 2;
            m_glyphDistillateButton._y = assembleButton._y + yOffset;
            m_glyphDistillateButton._width = width;
            m_glyphDistillateButton._height = width;
            
            m_glyphDistillateButton.onPress = Delegate.create(this, function(){ this.FindMatchingDistillates(this.GLYPH); } );
        }
        if (target == m_signetDistillateButton)
        {
            m_signetDistillateButton._x = assembleButton._x + xOffset + (width + 5) * 3;
            m_signetDistillateButton._y = assembleButton._y + yOffset;
            m_signetDistillateButton._width = width;
            m_signetDistillateButton._height = width;
            
            m_signetDistillateButton.onPress = Delegate.create(this, function(){ this.FindMatchingDistillates(this.SIGNET); } );
        }
        if (target == m_returnButton)
        {
            m_returnButton._x = assembleButton._x + xOffset + (width + 5) * 4;
            m_returnButton._y = assembleButton._y + yOffset;
            m_returnButton._width = width;
            m_returnButton._height = width;
            
            m_returnButton.onPress = Delegate.create(this, ClearSlots);
        }
    }
    
    function FindMatchingDistillates(realType:Number)
    {
        var freeSlots:Array = GetFreeEmpowermentSlots();
        if (freeSlots.length == 0) return;
        
        var itemsToMove:Array = [];
        for (var i = 0 ; i < m_inventory.GetMaxItems(); i++)
        {
            var item:InventoryItem = m_inventory.GetItemAt(i);
            if (item && item.m_RealType == realType && item.m_XP > 0)
            {
                itemsToMove.push(i);
            }
        }
        
        while (itemsToMove.length > 0 && freeSlots.length > 0)
        {
            var itemToMove = itemsToMove.pop();
            var freeSlot = freeSlots.pop();
            m_craftingInventory.AddItem(m_inventory.GetInventoryID(), itemToMove, freeSlot);
        }
    }
    
    function ClearSlots()
    {
        for (var i = EMPOWER_SLOT_0; i <= EMPOWER_SLOT_4; i++)
        {
            m_inventory.AddItem(m_craftingInventory.GetInventoryID(), i, m_inventory.GetFirstFreeItemSlot());
        }
    }
    
    function GetFreeEmpowermentSlots():Array
    {
        var freeslots:Array = [];
        for (var i = EMPOWER_SLOT_0; i <= EMPOWER_SLOT_4; i++)
        {
            if (!m_craftingInventory.GetItemAt(i)) freeslots.push(i);
        }
        return freeslots;
    }
}