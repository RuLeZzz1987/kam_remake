unit KM_GamePlayInterface;
interface
uses SysUtils, KromUtils, KromOGLUtils, Math, Classes, Controls, StrUtils, OpenGL,
  KM_Controls, KM_Houses, KM_Units, KM_Defaults;

type TKMMainMenuInterface = class
  private
    ScreenX,ScreenY:word;
    OffX,OffY:integer;
    TopSingleMap,ItemIndexSingleMap:integer;
  protected
    KMPanel_Main1:TKMPanel;
      L:array[1..20]of TKMLabel;
    KMPanel_MainMenu:TKMPanel;
      KMImage_MainMenuBG,KMImage_MainMenu1,KMImage_MainMenu3:TKMImage; //Menu background
      KMButton_MainMenuTutor,KMButton_MainMenuTSK,KMButton_MainMenuTPR,
      KMButton_MainMenuSingle,KMButton_MainMenuCredit,KMButton_MainMenuQuit:TKMButton;
      KMLabel_Version:TKMLabel;
    KMPanel_Single:TKMPanel;
      KMImage_SingleBG:TKMImage; //Single background
      KMButton_SingleHeadMode,KMButton_SingleHeadTeams,KMButton_SingleHeadTitle,KMButton_SingleHeadSize:TKMButton;
      KMButton_SingleBG:array[1..20,1..5]of TKMButtonFlat;
      KMButton_SingleMode:array[1..20]of TKMImage;
      KMButton_SinglePlayers,KMButton_SingleSize:array[1..20]of TKMLabel;
      KMLabel_SingleTitle1,KMLabel_SingleTitle2:array[1..20]of TKMLabel;
      KMButton_SingleScroll1:TKMImage;
      KMLabel_SingleDesc:TKMLabel;
      KMButton_SingleBack:TKMButton;
    KMPanel_Credits:TKMPanel;
      KMImage_CreditsBG:TKMImage; //Credits background
      KMButton_CreditsBack:TKMButton;
    KMPanel_Loading:TKMPanel;
      KMImage_LoadingBG:TKMImage;
      KMLabel_Loading:TKMLabel;
    KMPanel_Results:TKMPanel;
      KMImage_ResultsBG:TKMImage;
      KMButton_ResultsBack:TKMButton;
  private
    procedure SwitchMenuPage(Sender: TObject);
    procedure Play_Tutorial(Sender: TObject);
    procedure RefreshSingleMapPage();
  public
    MyControls: TKMControlsCollection;
    constructor Create(X,Y:word);
    destructor Destroy; override;
    procedure SetScreenSize(X,Y:word);
    procedure ShowScreen_Loading();
    procedure ShowScreen_Main();
    procedure ShowScreen_Results();
    procedure Create_MainMenu_Page;
    procedure Create_Single_Page;
    procedure Create_Credits_Page;
    procedure Create_Loading_Page;
    procedure Create_Results_Page;
  public
    procedure Paint;
end;

type TKMGamePlayInterface = class
  protected
    ShownUnit:TKMUnit;
    ShownHouse:TKMHouse;
    ShownHint:TObject;
    LastSchoolUnit:integer; //Last unit that was selected in School, global for all schools player owns
    LastBarrackUnit:integer;//Last unit that was selected in Barracks, global for all barracks player owns

    KMPanel_Main:TKMPanel;
      KMImage_Main1,KMImage_Main2,KMImage_Main3,KMImage_Main4:TKMImage; //Toolbar background
      KMMinimap:TKMMinimap;
      KMLabel_Hint:TKMLabel;
      KMButtonRun,KMButtonRun1,KMButtonStop:TKMButton;                //Start Village functioning
      KMButtonMain:array[1..5]of TKMButton; //4 common buttons + Return
      KMLabel_MenuTitle: TKMLabel; //Displays the title of the current menu to the right of return
    KMPanel_Ratios:TKMPanel;
      //
    KMPanel_Stats:TKMPanel;
      Stat_House,Stat_Unit:array[1..32]of TKMButtonFlat;
      Stat_HouseQty,Stat_UnitQty:array[1..32]of TKMLabel;

    KMPanel_Build:TKMPanel;
      KMLabel_Build:TKMLabel;
      KMImage_Build_Selected:TKMImage;
      KMImage_BuildCost_WoodPic:TKMImage;
      KMImage_BuildCdost_StonePic:TKMImage;
      KMLabel_BuildCost_Wood:TKMLabel;
      KMLabel_BuildCost_Stone:TKMLabel;
      KMButton_BuildRoad,KMButton_BuildField,KMButton_BuildWine,KMButton_BuildCancel:TKMButtonFlat;
      KMButton_Build:array[1..HOUSE_COUNT]of TKMButtonFlat;

    KMPanel_Menu:TKMPanel;
      KMButton_Menu_Save,KMButton_Menu_Load,KMButton_Menu_Settings,KMButton_Menu_Quit,KMButton_Menu_Track:TKMButton;
      KMLabel_Menu_Music, KMLabel_Menu_Track: TKMLabel;

      KMPanel_Save:TKMPanel;
        KMButton_Save:array[1..SAVEGAME_COUNT]of TKMButton;

      KMPanel_Load:TKMPanel;
        KMButton_Load:array[1..SAVEGAME_COUNT]of TKMButton;

      KMPanel_Settings:TKMPanel;
        KMLabel_Settings_Brightness,KMLabel_Settings_BrightValue:TKMLabel;
        KMButton_Settings_Dark,KMButton_Settings_Light:TKMButton;
        KMLabel_Settings_Autosave,KMLabel_Settings_FastScroll:TKMLabel;
        KMLabel_Settings_MouseSpeed,KMLabel_Settings_SFX,KMLabel_Settings_Music,KMLabel_Settings_Music2:TKMLabel;
        KMRatio_Settings_Mouse,KMRatio_Settings_SFX,KMRatio_Settings_Music:TKMRatioRow;
        KMButton_Settings_Music:TKMButton;

      KMPanel_Quit:TKMPanel;
        KMLabel_Quit:TKMLabel;
        KMButton_Quit_Yes,KMButton_Quit_No:TKMButton;

    KMPanel_Unit:TKMPanel;
      KMLabel_UnitName:TKMLabel;
      KMLabel_UnitCondition:TKMLabel;
      KMLabel_UnitTask:TKMLabel;
      KMLabel_UnitDescription:TKMLabel;
      KMConditionBar_Unit:TKMPercentBar;
      KMImage_UnitPic:TKMImage;
      
    KMPanel_House:TKMPanel;
      KMLabel_House:TKMLabel;
      KMButton_House_Goods,KMButton_House_Repair:TKMButton;
      KMImage_House_Logo,KMImage_House_Worker:TKMImage;
      KMHealthBar_House:TKMPercentBar;
      KMLabel_HouseHealth:TKMLabel;

    KMPanel_House_Common:TKMPanel;
      KMLabel_Common_Demand,KMLabel_Common_Offer,KMLabel_Common_Costs:TKMLabel;
      KMRow_Common_Resource:array[1..4]of TKMResourceRow; //4 bars is the maximum
      KMRow_Order:array[1..4]of TKMResourceOrderRow; //3 bars is the maximum
      KMRow_Costs:array[1..4]of TKMCostsRow; //3 bars is the maximum
    KMPanel_HouseStore:TKMPanel;
      KMButton_Store:array[1..28]of TKMButtonFlat;
      KMImage_Store_Accept:array[1..28]of TKMImage;
    KMPanel_House_School:TKMPanel;
      KMLabel_School_Res:TKMLabel;
      KMResRow_School_Resource:TKMResourceRow;
      KMButton_School_UnitWIP:TKMButton;
      KMButton_School_UnitWIPBar:TKMPercentBar;
      KMButton_School_UnitPlan:array[1..5]of TKMButtonFlat;
      KMLabel_School_Unit:TKMLabel;
      KMImage_School_Right,KMImage_School_Train,KMImage_School_Left:TKMImage;
      KMButton_School_Right,KMButton_School_Train,KMButton_School_Left:TKMButton;
    KMPanel_HouseBarracks:TKMPanel;
      KMButton_Barracks:array[1..12]of TKMButtonFlat;
  private
    procedure SwitchPage(Sender: TObject);
    procedure DisplayHint(Sender: TObject; AShift:TShiftState; X,Y:integer);
    procedure Minimap_Move(Sender: TObject; AShift:TShiftState; X,Y:integer);
    procedure BuildButtonClick(Sender: TObject);
    procedure Build_Fill(Sender:TObject);
    procedure StoreFill(Sender:TObject);
    procedure BarracksFill(Sender:TObject);
    procedure Stats_Fill(Sender:TObject);
  public
    MyControls: TKMControlsCollection;
    constructor Create;
    destructor Destroy; override;
    procedure Create_Build_Page;
    procedure Create_Ratios_Page;
    procedure Create_Stats_Page;
    procedure Create_Menu_Page;
    procedure Create_Save_Page;
    procedure Create_Load_Page;
    procedure Create_Settings_Page;
    procedure Create_Quit_Page;
    procedure Create_Unit_Page;
    procedure Create_House_Page;
    procedure Create_Store_Page;
    procedure Create_School_Page;
    procedure Create_Barracks_Page;
    procedure UpdateState;
    procedure RightClickCancel;
    procedure ShowSettings(Sender: TObject);
    procedure ShowLoad(Sender: TObject);
    procedure ShowHouseInfo(Sender:TKMHouse);
    procedure ShowUnitInfo(Sender:TKMUnit);
    procedure House_RepairToggle(Sender:TObject);
    procedure House_WareDeliveryToggle(Sender:TObject);
    procedure House_OrderClick(Sender:TObject);
    procedure House_OrderClickRight(Sender:TObject);
    procedure House_SchoolUnitChange(Sender:TObject);
    procedure House_SchoolUnitChangeRight(Sender:TObject);
    procedure House_SchoolUnitRemove(Sender:TObject);
    procedure House_StoreAcceptFlag(Sender:TObject);
    procedure Settings_Change(Sender:TObject);
    procedure QuitMission(Sender:TObject);
    procedure SelectRoad;
    procedure SetHintEvents(AHintEvent:TMouseMoveEvent);
    procedure EnableOrDisableMenuIcons;
  end;

var
  fGamePlayInterface: TKMGamePlayInterface;
  fMainMenuInterface: TKMMainMenuInterface;

implementation
uses KM_Unit1, KM_Users, KM_Settings, KM_Render, KM_LoadLib, KM_Terrain, KM_Viewport, KM_Game, KM_LoadDAT;


constructor TKMMainMenuInterface.Create(X,Y:word);
//var i:integer;
begin
inherited Create;
  {Parent Page for whole toolbar in-game}
  MyControls:=TKMControlsCollection.Create;
  ScreenX:=min(X,1024);
  ScreenY:=min(Y,768);
  OffX := (X-1024) div 2;
  OffY := (Y-768) div 2;
  TopSingleMap:=1;
  ItemIndexSingleMap:=1;

  KMPanel_Main1:=MyControls.AddPanel(nil,OffX,OffY,ScreenX,ScreenY);

  Create_MainMenu_Page;
  Create_Single_Page;
  Create_Credits_Page;
  Create_Loading_Page;
  Create_Results_Page;

  {for i:=1 to length(FontFiles) do
    L[i]:=MyControls.AddLabel(KMPanel_Main1,550,300+i*20,160,30,TKMFont(i),kaLeft,FontFiles[i]+' This is a test string for KaM Remake');
  //}

  //L[1]:=MyControls.AddLabel(KMPanel_Main,250,120,160,30,fnt_Outline,kaLeft,'This is a test'+#124+'string for'+#124+'KaM Remake'+#124+'text alignment'+#124+'indeed');
  //L[2]:=MyControls.AddLabel(KMPanel_Main,250,320,160,30,fnt_Outline,kaCenter,'This is a test'+#124+'string for'+#124+'KaM Remake'+#124+'text alignment'+#124+'indeed');
  //L[3]:=MyControls.AddLabel(KMPanel_Main,250,520,160,30,fnt_Outline,kaRight,'This is a test'+#124+'string for'+#124+'KaM Remake'+#124+'text alignment'+#124+'indeed');

  //Show version info on every page
  KMLabel_Version:=MyControls.AddLabel(KMPanel_Main1,5,5,100,30,GAME_VERSION,fnt_Antiqua,kaLeft);

  SwitchMenuPage(nil);
end;


destructor TKMMainMenuInterface.Destroy;
begin
  FreeAndNil(MyControls);
  inherited;
end;


procedure TKMMainMenuInterface.SetScreenSize(X,Y:word);
begin
  ScreenX:=X;
  ScreenY:=Y;
end;

procedure TKMMainMenuInterface.ShowScreen_Loading();
begin
  SwitchMenuPage(KMPanel_Loading);
end;

procedure TKMMainMenuInterface.ShowScreen_Main();
begin
  SwitchMenuPage(nil);
end;


procedure TKMMainMenuInterface.ShowScreen_Results();
begin
  SwitchMenuPage(KMPanel_Results);
end;


procedure TKMMainMenuInterface.Create_MainMenu_Page;
begin
  KMPanel_MainMenu:=MyControls.AddPanel(KMPanel_Main1,0,0,1024,768);
    KMImage_MainMenuBG:=MyControls.AddImage(KMPanel_MainMenu,0,0,ScreenX,ScreenY,2,5);
    KMImage_MainMenuBG.StretchImage:=true;
    KMImage_MainMenu1:=MyControls.AddImage(KMPanel_MainMenu,100,100,423,164,4,5);
    KMImage_MainMenu3:=MyControls.AddImage(KMPanel_MainMenu,640,220,207,295,6,5);
    KMImage_MainMenu3.StretchImage:=true;
    KMButton_MainMenuTutor :=MyControls.AddButton(KMPanel_MainMenu,100,400,350,30,fTextLibrary.GetSetupString(3),fnt_Metal);
    KMButton_MainMenuTutor.OnClick:=Play_Tutorial;
    KMButton_MainMenuTSK   :=MyControls.AddButton(KMPanel_MainMenu,100,440,350,30,fTextLibrary.GetSetupString(1),fnt_Metal);
    KMButton_MainMenuTSK.Disable;
    KMButton_MainMenuTPR   :=MyControls.AddButton(KMPanel_MainMenu,100,480,350,30,fTextLibrary.GetSetupString(2),fnt_Metal);
    KMButton_MainMenuTPR.Disable;
    KMButton_MainMenuSingle:=MyControls.AddButton(KMPanel_MainMenu,100,520,350,30,fTextLibrary.GetSetupString(4),fnt_Metal);
    KMButton_MainMenuSingle.OnClick:=SwitchMenuPage;
    //KMButton_MainMenuSingle.Disable; //@Lewin: I like to keep incomplete controls disabled )
    KMButton_MainMenuCredit:=MyControls.AddButton(KMPanel_MainMenu,100,560,350,30,fTextLibrary.GetSetupString(13),fnt_Metal);
    KMButton_MainMenuCredit.OnClick:=SwitchMenuPage;
    KMButton_MainMenuQuit  :=MyControls.AddButton(KMPanel_MainMenu,100,640,350,30,fTextLibrary.GetSetupString(14),fnt_Metal);
    KMButton_MainMenuQuit.OnClick:=Form1.Exit1.OnClick;
end;


procedure TKMMainMenuInterface.Create_Single_Page;
var i,k:integer;
begin
  KMPanel_Single:=MyControls.AddPanel(KMPanel_Main1,0,0,ScreenX,ScreenY);
    KMImage_SingleBG:=MyControls.AddImage(KMPanel_Single,0,0,ScreenX,ScreenY,2,5);
    KMImage_SingleBG.StretchImage:=true;
    KMButton_SingleHeadMode:=MyControls.AddButton(KMPanel_Single,50,140,48,40,42);
    KMButton_SingleHeadTeams:=MyControls.AddButton(KMPanel_Single,98,140,48,40,31);
    KMButton_SingleHeadTitle:=MyControls.AddButton(KMPanel_Single,146,140,320,40,'Title',fnt_Metal);
    KMButton_SingleHeadSize:=MyControls.AddButton(KMPanel_Single,466,140,48,40,'Size',fnt_Metal);
    for i:=1 to 10 do begin
      KMButton_SingleBG[i,1]:=MyControls.AddButtonFlat(KMPanel_Single,50,180+(i-1)*40,48,40,0);
      KMButton_SingleBG[i,2]:=MyControls.AddButtonFlat(KMPanel_Single,98,180+(i-1)*40,48,40,0);
      KMButton_SingleBG[i,3]:=MyControls.AddButtonFlat(KMPanel_Single,146,180+(i-1)*40,320,40,0);
      KMButton_SingleBG[i,4]:=MyControls.AddButtonFlat(KMPanel_Single,466,180+(i-1)*40,48,40,0);
      for k:=1 to 4 do KMButton_SingleBG[i,k].Disable;
      //KMButton_SingleBG[i,5]:=MyControls.AddButtonFlat(KMPanel_Single,100,180+(i-1)*40,464,40,0);

      KMButton_SingleMode[i]:=MyControls.AddImage(KMPanel_Single,50,180+(i-1)*40,48,40,28+random(2)*14);
      KMButton_SinglePlayers[i]:=MyControls.AddLabel(KMPanel_Single,98+24,180+(i-1)*40+14,48,40,'0',fnt_Outline, kaCenter);
      KMLabel_SingleTitle1[i]:=MyControls.AddLabel(KMPanel_Single,152,185+(i-1)*40,48,40,fTextLibrary.GetSetupString(random(29)),fnt_Metal, kaLeft);
      KMLabel_SingleTitle2[i]:=MyControls.AddLabel(KMPanel_Single,152,202+(i-1)*40,48,40,fTextLibrary.GetSetupString(random(29)),fnt_Game, kaLeft);
      KMButton_SingleSize[i]:=MyControls.AddLabel(KMPanel_Single,466+24,180+(i-1)*40+14,48,40,'0',fnt_Outline, kaCenter);
    end;

    KMButton_SingleScroll1:=MyControls.AddImage(KMPanel_Single,550,140,400,200,15,5);
    KMButton_SingleScroll1.StretchImage:=true;
    KMButton_SingleScroll1.Height:=200; //Need to reset it after stretching is enabled, cos it can't stretch down by default
    KMLabel_SingleDesc:=MyControls.AddLabel(KMPanel_Single,560,174,360,180,fTextLibrary.GetSetupString(350),fnt_Metal, kaLeft);
    KMLabel_SingleDesc.AutoWrap:=true;


    KMButton_SingleBack:=MyControls.AddButton(KMPanel_Single,50,640,224,30,fTextLibrary.GetSetupString(9),fnt_Metal);
    KMButton_SingleBack.OnClick:=SwitchMenuPage;
end;


procedure TKMMainMenuInterface.Create_Credits_Page;
begin
  KMPanel_Credits:=MyControls.AddPanel(KMPanel_Main1,0,0,ScreenX,ScreenY);
    KMImage_CreditsBG:=MyControls.AddImage(KMPanel_Credits,0,0,ScreenX,ScreenY,2,5);
    KMImage_CreditsBG.StretchImage:=true;
    KMButton_CreditsBack:=MyControls.AddButton(KMPanel_Credits,100,640,224,30,fTextLibrary.GetSetupString(9),fnt_Metal);
    KMButton_CreditsBack.OnClick:=SwitchMenuPage;
end;


procedure TKMMainMenuInterface.Create_Loading_Page;
begin
  KMPanel_Loading:=MyControls.AddPanel(KMPanel_Main1,0,0,ScreenX,ScreenY);
    KMImage_LoadingBG:=MyControls.AddImage(KMPanel_Loading,0,0,ScreenX,ScreenY,2,5);
    KMImage_LoadingBG.StretchImage:=true;
    KMLabel_Loading:=MyControls.AddLabel(KMPanel_Loading,ScreenX div 2,ScreenY div 2,100,30,'Loading... Please wait',fnt_Grey,kaCenter);
end;


procedure TKMMainMenuInterface.Create_Results_Page;
begin
  KMPanel_Results:=MyControls.AddPanel(KMPanel_Main1,0,0,ScreenX,ScreenY);
    KMImage_ResultsBG:=MyControls.AddImage(KMPanel_Results,0,0,ScreenX,ScreenY,7,5);
    KMImage_ResultsBG.StretchImage:=true;
    KMButton_ResultsBack:=MyControls.AddButton(KMPanel_Results,100,640,224,30,fTextLibrary.GetSetupString(9),fnt_Metal);
    KMButton_ResultsBack.OnClick:=SwitchMenuPage;
end;


procedure TKMMainMenuInterface.SwitchMenuPage(Sender: TObject);
var i:integer;
begin
  //First thing - hide all existing pages
  for i:=1 to KMPanel_Main1.ChildCount do
    if KMPanel_Main1.Childs[i] is TKMPanel then
      KMPanel_Main1.Childs[i].Hide;

  if Sender=nil then KMPanel_MainMenu.Show;
  
  if (Sender=KMButton_CreditsBack)or(Sender=KMButton_SingleBack)or(Sender=KMButton_ResultsBack) then
    KMPanel_MainMenu.Show;

  if Sender=KMButton_MainMenuCredit then
    KMPanel_Credits.Show;

  if Sender=KMButton_MainMenuSingle then begin
    RefreshSingleMapPage();
    KMPanel_Single.Show;
  end;

  if Sender=KMPanel_Loading then
    KMPanel_Loading.Show;

  if Sender=KMPanel_Results then //This page can be accessed only by itself
    KMPanel_Results.Show;
end;


procedure TKMMainMenuInterface.RefreshSingleMapPage();
var i:integer; MapInfo:TKMMapInfo;
begin
  MapInfo:=TKMMapInfo.Create;
  MapInfo.ScanSingleMapsFolder('');

  for i:=TopSingleMap to TopSingleMap+min(MapInfo.GetMapCount,10) do begin //Fill with existing maps
    KMButton_SingleMode[i].TexID:=28+byte(not MapInfo.IsFight(i))*14;
    KMButton_SinglePlayers[i].Caption:=inttostr(MapInfo.GetPlayerCount(i));
    KMLabel_SingleTitle1[i].Caption:=MapInfo.GetTitle(i);
    KMLabel_SingleTitle2[i].Caption:=MapInfo.GetSmallDesc(i);
    KMButton_SingleSize[i].Caption:=MapInfo.GetMapSize(i);
  end;
  for i:=TopSingleMap+min(MapInfo.GetMapCount,10) to TopSingleMap+9 do begin //Fill the rest if there's place left
    KMButton_SingleMode[i].TexID:=0;
    KMButton_SinglePlayers[i].Caption:='';
    KMLabel_SingleTitle1[i].Caption:='';
    KMLabel_SingleTitle2[i].Caption:='';
    KMButton_SingleSize[i].Caption:='';
  end;

  KMLabel_SingleDesc.Caption:=MapInfo.GetBigDesc(ItemIndexSingleMap);

  FreeAndNil(MapInfo);
end;


procedure TKMMainMenuInterface.Play_Tutorial(Sender: TObject);
begin
  Assert(Sender=KMButton_MainMenuTutor);
  fGame.StartGame('');
end;


{Reposition our 1024x768 interface to center of the render area}
procedure TKMMainMenuInterface.Paint;
begin
  MyControls.Paint;
end;


{Switch between pages}
procedure TKMGamePlayInterface.SwitchPage(Sender: TObject);
var i:integer; LastVisiblePage: TKMPanel;
  procedure Hide4MainButtons();
  var i:integer;
  begin
    for i:=1 to 4 do
      KMButtonMain[i].Hide;
    KMButtonMain[5].Show;
    KMLabel_MenuTitle.Show;
  end;  
  procedure Show4MainButtons();
  var i:integer;
  begin
    for i:=1 to 4 do
      KMButtonMain[i].Show;
    KMButtonMain[5].Hide;
    KMLabel_MenuTitle.Hide;
  end;
begin

if (Sender=KMButtonMain[1])or(Sender=KMButtonMain[2])or(Sender=KMButtonMain[3])or(Sender=KMButtonMain[4])or
   (Sender=KMButton_Menu_Settings)or(Sender=KMButton_Menu_Quit) then begin
  ShownHouse:=nil;
  ShownUnit:=nil;
end;

//Reset the CursorMode, to cm_None
BuildButtonClick(nil);

//Set LastVisiblePage to which ever page was last visible, out of the ones needed
if KMPanel_Settings.Visible = true then
  LastVisiblePage := KMPanel_Settings;
if KMPanel_Save.Visible = true then
  LastVisiblePage := KMPanel_Save;
if KMPanel_Load.Visible = true then
  LastVisiblePage := KMPanel_Load;

//First thing - hide all existing pages
  for i:=1 to KMPanel_Main.ChildCount do
    if KMPanel_Main.Childs[i] is TKMPanel then
      KMPanel_Main.Childs[i].Hide;
//First thing - hide all existing pages
  for i:=1 to KMPanel_House.ChildCount do
    if KMPanel_House.Childs[i] is TKMPanel then
      KMPanel_House.Childs[i].Hide;

//If Sender is one of 4 main buttons, then open the page, hide the buttons and show Return button
if Sender=KMButtonMain[1] then begin
  Build_Fill(nil);
  KMPanel_Build.Show;
  Hide4MainButtons;
  KMLabel_MenuTitle.Caption:=fTextLibrary.GetTextString(166);
  SelectRoad;
end else
if Sender=KMButtonMain[2] then begin
  KMPanel_Ratios.Show;
  Hide4MainButtons;
  KMLabel_MenuTitle.Caption:=fTextLibrary.GetTextString(167);
end else
if Sender=KMButtonMain[3] then begin
  Stats_Fill(nil);
  KMPanel_Stats.Show;
  Hide4MainButtons;
  KMLabel_MenuTitle.Caption:=fTextLibrary.GetTextString(168);
end else
if ((Sender=KMButtonMain[4]) or (Sender=KMButton_Quit_No) or
   ((Sender=KMButtonMain[5]) and (LastVisiblePage=KMPanel_Settings)) or
   ((Sender=KMButtonMain[5]) and (LastVisiblePage=KMPanel_Load)) or
   ((Sender=KMButtonMain[5]) and (LastVisiblePage=KMPanel_Save))) then begin
  KMPanel_Menu.Show;
  Hide4MainButtons;
  KMLabel_MenuTitle.Caption:=fTextLibrary.GetTextString(170);
end else
if Sender=KMButton_Menu_Save then begin
  KMPanel_Save.Show;
  Hide4MainButtons;
  KMLabel_MenuTitle.Caption:=fTextLibrary.GetTextString(173);
end else
if Sender=KMButton_Menu_Load then begin
  KMPanel_Load.Show;
  Hide4MainButtons;
  KMLabel_MenuTitle.Caption:=fTextLibrary.GetTextString(172);
end else
if Sender=KMButton_Menu_Settings then begin
  KMPanel_Settings.Show;
  Hide4MainButtons;
  KMLabel_MenuTitle.Caption:=fTextLibrary.GetTextString(179);
end else
if Sender=KMButton_Menu_Quit then begin
  KMPanel_Quit.Show;
  Hide4MainButtons;
end else //If Sender is anything else - then show all 4 buttons and hide Return button
  Show4MainButtons;

//Now process all other kinds of pages
if Sender=KMPanel_Unit then begin
  TKMPanel(Sender).Show;
end else
if Sender=KMPanel_House then begin
  TKMPanel(Sender).Show;
end;
if Sender=KMPanel_House_Common then begin
  TKMPanel(Sender).Parent.Show;
  TKMPanel(Sender).Show;
end else
if Sender=KMPanel_House_School then begin
  TKMPanel(Sender).Parent.Show;
  TKMPanel(Sender).Show;
end else
if Sender=KMPanel_HouseBarracks then begin
  TKMPanel(Sender).Parent.Show;
  TKMPanel(Sender).Show;
end else
if Sender=KMPanel_HouseStore then begin
  TKMPanel(Sender).Parent.Show;
  TKMPanel(Sender).Show;
end;

end;


procedure TKMGamePlayInterface.DisplayHint(Sender: TObject; AShift:TShiftState; X,Y:integer);
var RandomNum: string;
begin
  RandomNum := '    '+inttostr(random(9)); //Random numbers here are to show every time hint gets refreshed
  ShownHint:=Sender;
  if((ShownHint<>nil) and ((not TKMControl(ShownHint).CursorOver) or (not TKMControl(ShownHint).Visible)) ) then ShownHint:=nil; //only set if cursor is over and control is visible
  if ((ShownHint<>nil) and (TKMControl(ShownHint).Parent <> nil)) then //only set if parent is visible (e.g. panel)
    if (ShownHint<>nil)and(not (ShownHint as TKMControl).Parent.Visible) then ShownHint:=nil;

  KMLabel_Hint.Top:=fRender.GetRenderAreaSize.Y-16;
  //If hint hasn't changed then don't refresh it
  if ((ShownHint<>nil) and (LeftStr(KMLabel_Hint.Caption,Length(KMLabel_Hint.Caption)-Length(RandomNum)) = TKMControl(Sender).Hint)) then exit;
  if ((ShownHint=nil) and (Length(KMLabel_Hint.Caption) = Length(RandomNum))) then exit;
  if ShownHint=nil then KMLabel_Hint.Caption:=''+RandomNum else
    KMLabel_Hint.Caption:=(Sender as TKMControl).Hint+RandomNum;
end;


procedure TKMGamePlayInterface.Minimap_Move(Sender: TObject; AShift:TShiftState; X,Y:integer);
begin
  KMMinimap.MapSize:=KMPoint(fTerrain.MapX,fTerrain.MapY);

  if Sender<>nil then
    fViewport.SetCenter(KMMinimap.CenteredAt.X,KMMinimap.CenteredAt.Y);

  KMMinimap.CenteredAt:=fViewport.GetCenter;
  KMMinimap.ViewArea:=fViewport.GetClip;
end;


constructor TKMGamePlayInterface.Create();
var i:integer;
begin
inherited;
Assert(fGameSettings<>nil,'fGameSettings required to be init first');
Assert(fViewport<>nil,'fViewport required to be init first');

  MyControls:=TKMControlsCollection.Create;

  ShownUnit:=nil;
  ShownHouse:=nil;

  LastSchoolUnit:=1;
  LastBarrackUnit:=1;
{Parent Page for whole toolbar in-game}
  KMPanel_Main:=MyControls.AddPanel(nil,0,0,224,768);

    KMImage_Main1:=MyControls.AddImage(KMPanel_Main,0,0,224,200,407);
    KMImage_Main3:=MyControls.AddImage(KMPanel_Main,0,200,224,168,554);
    KMImage_Main4:=MyControls.AddImage(KMPanel_Main,0,368,224,400,404);

    KMMinimap:=MyControls.AddMinimap(KMPanel_Main,10,10,176,176);
    KMMinimap.OnMouseOver:=Minimap_Move;

    //This is button to start Village functioning
    KMButtonRun:=MyControls.AddButton(KMPanel_Main,20,205,50,30,36);
    KMButtonRun.OnClick:=Form1.Button1Click; //Procedure where stuff is placed on map

    KMButtonRun1:=MyControls.AddButton(KMPanel_Main,80,205,50,30,'6',fnt_Outline);
    KMButtonRun1.OnClick:=Form1.Button2Click; //Procedure where stuff is placed on map

    KMButtonStop:=MyControls.AddButton(KMPanel_Main,140,205,50,30,'Stop',fnt_Outline);
    KMButtonStop.OnClick:=Form1.Button3Click; //Procedure where all stuff is removed from map

    {Main 4 buttons +return button}
    for i:=0 to 3 do begin
      KMButtonMain[i+1]:=MyControls.AddButton(KMPanel_Main,  8+46*i, 372, 42, 36, 439+i);
      KMButtonMain[i+1].OnClick:=SwitchPage;
      KMButtonMain[i+1].Hint:=fTextLibrary.GetTextString(160+i);
    end;
    KMButtonMain[4].Hint:=fTextLibrary.GetTextString(164); //This is an exception to the rule above
    KMButtonMain[5]:=MyControls.AddButton(KMPanel_Main,  8, 372, 42, 36, 443);
    KMButtonMain[5].OnClick:=SwitchPage;
    KMButtonMain[5].Hint:=fTextLibrary.GetTextString(165);
    KMLabel_MenuTitle:=MyControls.AddLabel(KMPanel_Main,54,372,138,36,'',fnt_Metal,kaLeft);

    KMLabel_Hint:=MyControls.AddLabel(KMPanel_Main,224+8,fRender.GetRenderAreaSize.Y-16,0,0,'',fnt_Outline,kaLeft);

{I plan to store all possible layouts on different pages which gets displayed one at a time}
{==========================================================================================}
  Create_Build_Page();
  Create_Ratios_Page();
  Create_Stats_Page();
  Create_Menu_Page();
    Create_Save_Page();
    Create_Load_Page();
    Create_Settings_Page();
    Create_Quit_Page();

  Create_Unit_Page();
  Create_House_Page();
    Create_Store_Page();
    Create_School_Page();
    Create_Barracks_Page();

  SetHintEvents(DisplayHint); //Set all OnHint events to be the correct function

  SwitchPage(nil); //Update
end;


destructor TKMGamePlayInterface.Destroy;
begin
  FreeAndNil(MyControls);
  inherited;
end;


{Build page}
procedure TKMGamePlayInterface.Create_Build_Page;
var i:integer;
begin
  KMPanel_Build:=MyControls.AddPanel(KMPanel_Main,0,412,196,400);
    KMLabel_Build:=MyControls.AddLabel(KMPanel_Build,100,10,100,30,'',fnt_Outline,kaCenter);
    KMImage_Build_Selected:=MyControls.AddImage(KMPanel_Build,8,40,32,32,335);
    KMImage_BuildCost_WoodPic:=MyControls.AddImage(KMPanel_Build,75,40,32,32,353);
    KMImage_BuildCdost_StonePic:=MyControls.AddImage(KMPanel_Build,130,40,32,32,352);
    KMLabel_BuildCost_Wood:=MyControls.AddLabel(KMPanel_Build,105,50,10,30,'',fnt_Outline,kaLeft);
    KMLabel_BuildCost_Stone:=MyControls.AddLabel(KMPanel_Build,160,50,10,30,'',fnt_Outline,kaLeft);
    KMButton_BuildRoad   := MyControls.AddButtonFlat(KMPanel_Build,  8,80,33,33,335);
    KMButton_BuildField  := MyControls.AddButtonFlat(KMPanel_Build, 45,80,33,33,337);
    KMButton_BuildWine   := MyControls.AddButtonFlat(KMPanel_Build, 82,80,33,33,336);
    KMButton_BuildCancel := MyControls.AddButtonFlat(KMPanel_Build,156,80,33,33,340);
    KMButton_BuildRoad.OnClick:=BuildButtonClick;
    KMButton_BuildField.OnClick:=BuildButtonClick;
    KMButton_BuildWine.OnClick:=BuildButtonClick;
    KMButton_BuildCancel.OnClick:=BuildButtonClick;
    KMButton_BuildRoad.Hint:=fTextLibrary.GetTextString(213);
    KMButton_BuildField.Hint:=fTextLibrary.GetTextString(215);
    KMButton_BuildWine.Hint:=fTextLibrary.GetTextString(219);
    KMButton_BuildCancel.Hint:=fTextLibrary.GetTextString(211);

    for i:=1 to HOUSE_COUNT do begin
      KMButton_Build[i]:=MyControls.AddButtonFlat(KMPanel_Build, 8+((i-1) mod 5)*37,120+((i-1) div 5)*37,33,33,GUIBuildIcons[i]);
      KMButton_Build[i].OnClick:=BuildButtonClick;
      KMButton_Build[i].Hint:=fTextLibrary.GetTextString(GUIBuildIcons[i]-300);
    end;
end;


{Ratios page}
procedure TKMGamePlayInterface.Create_Ratios_Page;
begin
  KMPanel_Ratios:=MyControls.AddPanel(KMPanel_Main,0,412,200,400);
end;


{Statistics page}
procedure TKMGamePlayInterface.Create_Stats_Page;
var i,k,ci:integer;
begin
  KMPanel_Stats:=MyControls.AddPanel(KMPanel_Main,0,412,200,400);
  ci:=0;
  for i:=1 to 11 do for k:=1 to 4 do
  if StatHouseOrder[i,k]<>ht_None then begin
    inc(ci);
    Stat_House[ci]:=MyControls.AddButtonFlat(KMPanel_Stats,8+(k-1)*42,(i-1)*32,40,30,41);
    Stat_House[ci].TexOffsetX:=-4;
    Stat_House[ci].HideHighlight:=true;
    Stat_House[ci].Hint:=TypeToString(StatHouseOrder[i,k]);
    Stat_HouseQty[ci]:=MyControls.AddLabel(KMPanel_Stats,8+37+(k-1)*42,(i-1)*32+18,33,30,'',fnt_Grey,kaRight);
    Stat_HouseQty[ci].Hint:=TypeToString(StatHouseOrder[i,k]);
  end;              
  ci:=0;
  for i:=1 to 11 do for k:=1 to 5 do
  if StatUnitOrder[i,k]<>ut_None then begin     
    inc(ci);
    Stat_Unit[ci]:=MyControls.AddButtonFlat(KMPanel_Stats,8+(k-1)*36,(i-1)*32,35,30,byte(StatUnitOrder[i,k])+140);
    Stat_Unit[ci].TexOffsetX:=-4;
    Stat_Unit[ci].HideHighlight:=true;
    Stat_Unit[ci].Hint:=TypeToString(StatUnitOrder[i,k]);
    Stat_UnitQty[ci]:=MyControls.AddLabel(KMPanel_Stats,8+32+(k-1)*36,(i-1)*32+18,33,30,'',fnt_Grey,kaRight);
    Stat_UnitQty[ci].Hint:=TypeToString(StatUnitOrder[i,k]);
  end;
end;


{Menu page}
procedure TKMGamePlayInterface.Create_Menu_Page;
begin
  KMPanel_Menu:=MyControls.AddPanel(KMPanel_Main,0,412,196,400);
    KMButton_Menu_Save:=MyControls.AddButton(KMPanel_Menu,8,20,180,30,fTextLibrary.GetTextString(175),fnt_Metal);
    KMButton_Menu_Save.OnClick:=ShowLoad;
    KMButton_Menu_Save.Hint:=fTextLibrary.GetTextString(175);
    KMButton_Menu_Load:=MyControls.AddButton(KMPanel_Menu,8,60,180,30,fTextLibrary.GetTextString(174),fnt_Metal);
    KMButton_Menu_Load.OnClick:=ShowLoad;
    KMButton_Menu_Load.Hint:=fTextLibrary.GetTextString(174);
    KMButton_Menu_Settings:=MyControls.AddButton(KMPanel_Menu,8,100,180,30,fTextLibrary.GetTextString(179),fnt_Metal);
    KMButton_Menu_Settings.OnClick:=ShowSettings;
    KMButton_Menu_Settings.Hint:=fTextLibrary.GetTextString(179);
    KMButton_Menu_Quit:=MyControls.AddButton(KMPanel_Menu,8,180,180,30,fTextLibrary.GetTextString(180),fnt_Metal);
    KMButton_Menu_Quit.Hint:=fTextLibrary.GetTextString(180);
    KMButton_Menu_Quit.OnClick:=SwitchPage;
    KMButton_Menu_Track:=MyControls.AddButton(KMPanel_Menu,158,320,30,30,'>',fnt_Metal);
    KMButton_Menu_Track.Hint:=fTextLibrary.GetTextString(209);
    //KMButton_Menu_Quit.OnClick:=TrackUp;
    KMLabel_Menu_Music:=MyControls.AddLabel(KMPanel_Menu,100,298,100,30,fTextLibrary.GetTextString(207),fnt_Metal,kaCenter);
    KMLabel_Menu_Track:=MyControls.AddLabel(KMPanel_Menu,100,326,100,30,'Spirit',fnt_Grey,kaCenter);
end;


{Save page}
procedure TKMGamePlayInterface.Create_Save_Page;
var i:integer;
begin
  KMPanel_Save:=MyControls.AddPanel(KMPanel_Main,0,412,200,400);
    for i:=1 to SAVEGAME_COUNT do begin
      KMButton_Save[i]:=MyControls.AddButton(KMPanel_Save,12,10+(i-1)*26,170,24,'Savegame #'+inttostr(i),fnt_Grey);
      //KMButton_Save[i].OnClick:=SaveGame;
      KMButton_Save[i].Disable;
    end;
end;


{Load page}
procedure TKMGamePlayInterface.Create_Load_Page;
var i:integer;
begin
  KMPanel_Load:=MyControls.AddPanel(KMPanel_Main,0,412,200,400);
    for i:=1 to SAVEGAME_COUNT do begin
      KMButton_Load[i]:=MyControls.AddButton(KMPanel_Load,12,10+(i-1)*26,170,24,'Savegame #'+inttostr(i),fnt_Grey);
      //KMButton_Load[i].OnClick:=LoadGame;
      KMButton_Load[i].Disable;
    end;
end;


{Options page}
procedure TKMGamePlayInterface.Create_Settings_Page;
var i:integer;
begin
  KMPanel_Settings:=MyControls.AddPanel(KMPanel_Main,0,412,200,400);
    KMLabel_Settings_Brightness:=MyControls.AddLabel(KMPanel_Settings,100,10,100,30,fTextLibrary.GetTextString(181),fnt_Metal,kaCenter);
    KMButton_Settings_Dark:=MyControls.AddButton(KMPanel_Settings,8,30,36,24,fTextLibrary.GetTextString(183),fnt_Metal);
    KMButton_Settings_Light:=MyControls.AddButton(KMPanel_Settings,154,30,36,24,fTextLibrary.GetTextString(182),fnt_Metal);
    KMButton_Settings_Dark.Hint:=fTextLibrary.GetTextString(185);
    KMButton_Settings_Light.Hint:=fTextLibrary.GetTextString(184);
    KMLabel_Settings_BrightValue:=MyControls.AddLabel(KMPanel_Settings,100,34,100,30,'',fnt_Grey,kaCenter);
    KMLabel_Settings_Autosave:=MyControls.AddLabel(KMPanel_Settings,8,70,100,30,'',fnt_Metal,kaLeft);
    KMLabel_Settings_Autosave.Disable;
    KMLabel_Settings_FastScroll:=MyControls.AddLabel(KMPanel_Settings,8,95,100,30,'',fnt_Metal,kaLeft);
    KMLabel_Settings_MouseSpeed:=MyControls.AddLabel(KMPanel_Settings,24,130,100,30,fTextLibrary.GetTextString(192),fnt_Metal,kaLeft);
    KMLabel_Settings_MouseSpeed.Disable;
    KMRatio_Settings_Mouse:=MyControls.AddRatioRow(KMPanel_Settings,18,150,160,20);
    KMRatio_Settings_Mouse.Disable;
    KMRatio_Settings_Mouse.MaxValue:=fGameSettings.GetSlidersMax;
    KMRatio_Settings_Mouse.MinValue:=fGameSettings.GetSlidersMin;
    KMRatio_Settings_Mouse.Hint:=fTextLibrary.GetTextString(193);
    KMLabel_Settings_SFX:=MyControls.AddLabel(KMPanel_Settings,24,178,100,30,fTextLibrary.GetTextString(194),fnt_Metal,kaLeft);
    KMRatio_Settings_SFX:=MyControls.AddRatioRow(KMPanel_Settings,18,198,160,20);
    KMRatio_Settings_SFX.MaxValue:=fGameSettings.GetSlidersMax;
    KMRatio_Settings_SFX.MinValue:=fGameSettings.GetSlidersMin;
    KMRatio_Settings_SFX.Hint:=fTextLibrary.GetTextString(195);
    KMLabel_Settings_Music:=MyControls.AddLabel(KMPanel_Settings,24,226,100,30,fTextLibrary.GetTextString(196),fnt_Metal,kaLeft);
    KMLabel_Settings_Music.Disable;
    KMRatio_Settings_Music:=MyControls.AddRatioRow(KMPanel_Settings,18,246,160,20);
    KMRatio_Settings_Music.Disable;
    KMRatio_Settings_Music.MaxValue:=fGameSettings.GetSlidersMax;
    KMRatio_Settings_Music.MinValue:=fGameSettings.GetSlidersMin;
    KMRatio_Settings_Music.Hint:=fTextLibrary.GetTextString(195);
    KMLabel_Settings_Music2:=MyControls.AddLabel(KMPanel_Settings,100,280,100,30,fTextLibrary.GetTextString(197),fnt_Metal,kaCenter);
    KMButton_Settings_Music:=MyControls.AddButton(KMPanel_Settings,8,300,180,30,'',fnt_Metal);
    KMButton_Settings_Music.Hint:=fTextLibrary.GetTextString(198);
    //There are many clickable controls, so let them all be handled in one procedure to save dozens of lines of code
    for i:=1 to KMPanel_Settings.ChildCount do
    begin
      TKMControl(KMPanel_Settings.Childs[i]).OnClick:=Settings_Change;
      TKMControl(KMPanel_Settings.Childs[i]).OnChange:=Settings_Change;
    end;
end;


{Quit page}
procedure TKMGamePlayInterface.Create_Quit_Page;
begin
  KMPanel_Quit:=MyControls.AddPanel(KMPanel_Main,0,412,200,400);
    KMLabel_Quit:=MyControls.AddLabel(KMPanel_Quit,100,30,100,30,fTextLibrary.GetTextString(176),fnt_Outline,kaCenter);
    KMButton_Quit_Yes:=MyControls.AddButton(KMPanel_Quit,8,100,180,30,fTextLibrary.GetTextString(177),fnt_Metal);
    KMButton_Quit_No:=MyControls.AddButton(KMPanel_Quit,8,140,180,30,fTextLibrary.GetTextString(178),fnt_Metal);
    KMButton_Quit_Yes.Hint:=fTextLibrary.GetTextString(177);
    KMButton_Quit_No.Hint:=fTextLibrary.GetTextString(178);
    KMButton_Quit_Yes.OnClick:=QuitMission;
    KMButton_Quit_No.OnClick:=SwitchPage;
end;


{Unit page}
procedure TKMGamePlayInterface.Create_Unit_Page;
begin
  KMPanel_Unit:=MyControls.AddPanel(KMPanel_Main,0,412,200,400);
    KMLabel_UnitName:=MyControls.AddLabel(KMPanel_Unit,100,30,100,30,'',fnt_Outline,kaCenter);
    KMLabel_UnitCondition:=MyControls.AddLabel(KMPanel_Unit,130,54,100,30,fTextLibrary.GetTextString(254),fnt_Grey,kaCenter);
    KMLabel_UnitTask:=MyControls.AddLabel(KMPanel_Unit,73,89,100,30,'',fnt_Grey,kaLeft);
    KMConditionBar_Unit:=MyControls.AddPercentBar(KMPanel_Unit,73,69,116,15,80);
    KMLabel_UnitDescription:=MyControls.AddLabel(KMPanel_Unit,8,161,236,200,'',fnt_Grey,kaLeft); //Taken from LIB resource
    KMImage_UnitPic:=MyControls.AddImage(KMPanel_Unit,8,52,54,80,521);
end;


{House description page}
procedure TKMGamePlayInterface.Create_House_Page;
var i:integer;
begin
  KMPanel_House:=MyControls.AddPanel(KMPanel_Main,0,412,200,400);
    //Thats common things
    //Custom things come in fixed size blocks (more smaller Panels?), and to be shown upon need
    KMLabel_House:=MyControls.AddLabel(KMPanel_House,100,14,100,30,'',fnt_Outline,kaCenter);
    KMButton_House_Goods:=MyControls.AddButton(KMPanel_House,9,42,30,30,37);
    KMButton_House_Goods.OnClick := fGamePlayInterface.House_WareDeliveryToggle;
    KMButton_House_Goods.Hint := fTextLibrary.GetTextString(249);
    KMButton_House_Repair:=MyControls.AddButton(KMPanel_House,39,42,30,30,40);
    KMButton_House_Repair.OnClick := fGamePlayInterface.House_RepairToggle;
    KMButton_House_Repair.Disable;
    KMButton_House_Repair.Hint := fTextLibrary.GetTextString(250);
    KMImage_House_Logo:=MyControls.AddImage(KMPanel_House,68,41,32,32,338);
    KMImage_House_Worker:=MyControls.AddImage(KMPanel_House,98,41,32,32,141);
    KMLabel_HouseHealth:=MyControls.AddLabel(KMPanel_House,156,45,30,50,fTextLibrary.GetTextString(228),fnt_Mini,kaCenter,$FFFFFFFF);
    KMHealthBar_House:=MyControls.AddPercentBar(KMPanel_House,129,57,55,15,50,'',fnt_Mini);

    KMPanel_House_Common:=MyControls.AddPanel(KMPanel_House,0,76,200,400);
      KMLabel_Common_Demand:=MyControls.AddLabel(KMPanel_House_Common,100,2,100,30,fTextLibrary.GetTextString(227),fnt_Grey,kaCenter);
      KMLabel_Common_Offer:=MyControls.AddLabel(KMPanel_House_Common,100,2,100,30,'',fnt_Grey,kaCenter);
      KMLabel_Common_Costs:=MyControls.AddLabel(KMPanel_House_Common,100,2,100,30,fTextLibrary.GetTextString(248),fnt_Grey,kaCenter);
      KMRow_Common_Resource[1] :=MyControls.AddResourceRow(KMPanel_House_Common,  8,22,180,20,rt_Trunk,5);
      KMRow_Common_Resource[2] :=MyControls.AddResourceRow(KMPanel_House_Common,  8,42,180,20,rt_Stone,5);
      KMRow_Common_Resource[3] :=MyControls.AddResourceRow(KMPanel_House_Common,  8,62,180,20,rt_Trunk,5);
      KMRow_Common_Resource[4] :=MyControls.AddResourceRow(KMPanel_House_Common,  8,82,180,20,rt_Stone,5);
      for i:=1 to 4 do begin
        KMRow_Order[i] :=MyControls.AddResourceOrderRow(KMPanel_House_Common,  8,22,180,20,rt_Trunk,5);
        KMRow_Order[i].OrderRem.OnClick:=House_OrderClick;
        KMRow_Order[i].OrderRem.OnRightClick:=House_OrderClickRight;
        KMRow_Order[i].OrderRem.Hint:=fTextLibrary.GetTextString(234);
        KMRow_Order[i].OrderAdd.OnClick:=House_OrderClick;
        KMRow_Order[i].OrderAdd.OnRightClick:=House_OrderClickRight;
        KMRow_Order[i].OrderAdd.Hint:=fTextLibrary.GetTextString(235);
      end;
      KMRow_Costs[1] :=MyControls.AddCostsRow(KMPanel_House_Common,  8,22,180,20, 1);
      KMRow_Costs[2] :=MyControls.AddCostsRow(KMPanel_House_Common,  8,22,180,20, 1);
      KMRow_Costs[3] :=MyControls.AddCostsRow(KMPanel_House_Common,  8,22,180,20, 1);
      KMRow_Costs[4] :=MyControls.AddCostsRow(KMPanel_House_Common,  8,22,180,20, 1);
end;

{Store page}
procedure TKMGamePlayInterface.Create_Store_Page;
var i:integer;
begin
    KMPanel_HouseStore:=MyControls.AddPanel(KMPanel_House,0,76,200,400);
      for i:=1 to 28 do begin
        KMButton_Store[i]:=MyControls.AddButtonFlat(KMPanel_HouseStore, 8+((i-1)mod 5)*36,19+((i-1)div 5)*42,32,36,350+i);
        KMButton_Store[i].OnClick:=House_StoreAcceptFlag;
        KMButton_Store[i].Tag:=i;
        KMButton_Store[i].Hint:=TypeToString(TResourceType(i));
        KMButton_Store[i].HideHighlight:=true;
        KMImage_Store_Accept[i]:=MyControls.AddImage(KMPanel_HouseStore, 8+((i-1)mod 5)*36+9,18+((i-1)div 5)*42-11,32,36,49);
        KMImage_Store_Accept[i].FOnClick:=House_StoreAcceptFlag;
        KMImage_Store_Accept[i].Hint:=TypeToString(TResourceType(i));
      end;
end;


{School page}
procedure TKMGamePlayInterface.Create_School_Page;
var i:integer;
begin
    KMPanel_House_School:=MyControls.AddPanel(KMPanel_House,0,76,200,400);
      KMLabel_School_Res:=MyControls.AddLabel(KMPanel_House_School,100,2,100,30,fTextLibrary.GetTextString(227),fnt_Grey,kaCenter);
      KMResRow_School_Resource :=MyControls.AddResourceRow(KMPanel_House_School,  8,22,180,20,rt_Gold,5);
      KMResRow_School_Resource.Hint :=TypeToString(rt_Gold);
      KMButton_School_UnitWIP :=MyControls.AddButton(KMPanel_House_School,  8,48,32,32,0);
      KMButton_School_UnitWIP.Hint:=fTextLibrary.GetTextString(225);
      KMButton_School_UnitWIPBar:=MyControls.AddPercentBar(KMPanel_House_School,42,54,138,20,0);
      KMButton_School_UnitWIP.OnClick:= House_SchoolUnitRemove;
      for i:=1 to 5 do begin
        KMButton_School_UnitPlan[i]:= MyControls.AddButtonFlat(KMPanel_House_School, 8+(i-1)*36,80,32,32,0);
        KMButton_School_UnitPlan[i].OnClick:= House_SchoolUnitRemove;
      end;
      KMLabel_School_Unit:=MyControls.AddLabel(KMPanel_House_School,100,116,100,30,'',fnt_Outline,kaCenter);
      KMImage_School_Left :=MyControls.AddImage(KMPanel_House_School,  8,136,54,80,521);
      KMImage_School_Left.Enabled := false;
      KMImage_School_Train:=MyControls.AddImage(KMPanel_House_School, 70,136,54,80,522);
      KMImage_School_Right:=MyControls.AddImage(KMPanel_House_School,132,136,54,80,523);
      KMImage_School_Right.Enabled := false;
      KMButton_School_Left :=MyControls.AddButton(KMPanel_House_School,  8,226,54,40,35);
      KMButton_School_Train:=MyControls.AddButton(KMPanel_House_School, 70,226,54,40,42);
      KMButton_School_Right:=MyControls.AddButton(KMPanel_House_School,132,226,54,40,36);
      KMButton_School_Left.OnClick:=House_SchoolUnitChange;
      KMButton_School_Train.OnClick:=House_SchoolUnitChange;
      KMButton_School_Right.OnClick:=House_SchoolUnitChange;
      KMButton_School_Left.OnRightClick:=House_SchoolUnitChangeRight;
      KMButton_School_Right.OnRightClick:=House_SchoolUnitChangeRight;
      KMButton_School_Left.Hint :=fTextLibrary.GetTextString(242);
      KMButton_School_Train.Hint:=fTextLibrary.GetTextString(243);
      KMButton_School_Right.Hint:=fTextLibrary.GetTextString(241);
end;


{Barracks page}
procedure TKMGamePlayInterface.Create_Barracks_Page;
var i:integer;
begin
    KMPanel_HouseBarracks:=MyControls.AddPanel(KMPanel_House,0,76,200,400);
      for i:=1 to 12 do
      begin
        KMButton_Barracks[i]:=MyControls.AddButtonFlat(KMPanel_HouseBarracks, 8+((i-1)mod 6)*31,19+((i-1)div 6)*42,28,36,366+i);
        KMButton_Barracks[i].Hint:=TypeToString(TResourceType(16+i));
      end;
      KMButton_Barracks[12].TexID:=154;
      KMButton_Barracks[12].Hint:=TypeToString(ut_Recruit);
end;


{Should update any items changed by game (resoource counts, hp, etc..)}
{If it ever gets a bottleneck then some static Controls may be excluded from update}
procedure TKMGamePlayInterface.UpdateState;
begin
  if ShownUnit<>nil then ShowUnitInfo(ShownUnit) else
  if ShownHouse<>nil then ShowHouseInfo(ShownHouse);

  if ShownHint<>nil then DisplayHint(ShownHint,[],0,0);
  if Mouse.CursorPos.X>ToolBarWidth then DisplayHint(nil,[],0,0); //Don't display hints if not over ToolBar

  Minimap_Move(nil,[],0,0);

  if KMPanel_Build.Visible then Build_Fill(nil);
  if KMPanel_Stats.Visible then Stats_Fill(nil);
  EnableOrDisableMenuIcons;
end;


procedure TKMGamePlayInterface.BuildButtonClick(Sender: TObject);
var i:integer;
begin
  if Sender=nil then begin CursorMode.Mode:=cm_None; exit; end;

  //Release all buttons
  for i:=1 to KMPanel_Build.ChildCount do
    if KMPanel_Build.Childs[i] is TKMButtonFlat then
      TKMButtonFlat(KMPanel_Build.Childs[i]).Down:=false;

  //Press the button
  TKMButtonFlat(Sender).Down:=true;

  //Reset cursor and see if it needs to be changed
  CursorMode.Mode:=cm_None;
  CursorMode.Param:=0;
  KMLabel_BuildCost_Wood.Caption:='-';
  KMLabel_BuildCost_Stone.Caption:='-';
  KMLabel_Build.Caption := '';

  
  if KMButton_BuildCancel.Down then begin
    CursorMode.Mode:=cm_Erase;
    KMImage_Build_Selected.TexID := 340;
    KMLabel_Build.Caption := fTextLibrary.GetTextString(210);
  end;
  if KMButton_BuildRoad.Down then begin
    CursorMode.Mode:=cm_Road;
    KMImage_Build_Selected.TexID := 335;
    KMLabel_BuildCost_Stone.Caption:='1';
    KMLabel_Build.Caption := fTextLibrary.GetTextString(212);
  end;
  if KMButton_BuildField.Down then begin
    CursorMode.Mode:=cm_Field;
    KMImage_Build_Selected.TexID := 337;
    KMLabel_Build.Caption := fTextLibrary.GetTextString(214);
  end;
  if KMButton_BuildWine.Down then begin
    CursorMode.Mode:=cm_Wine;
    KMImage_Build_Selected.TexID := 336;
    KMLabel_BuildCost_Wood.Caption:='1';
    KMLabel_Build.Caption := fTextLibrary.GetTextString(218);
  end;

  for i:=1 to HOUSE_COUNT do
  if KMButton_Build[i].Down then begin
     CursorMode.Mode:=cm_Houses;
     CursorMode.Param:=GUIBuildIcons[i]-300; // -300 Thats a shortcut, I know
     KMImage_Build_Selected.TexID := GUIBuildIcons[i]; //Now update the selected icon
     KMLabel_BuildCost_Wood.Caption:=inttostr(HouseDAT[GUIBuildIcons[i]-300].WoodCost);
     KMLabel_BuildCost_Stone.Caption:=inttostr(HouseDAT[GUIBuildIcons[i]-300].StoneCost);
     KMLabel_Build.Caption := TypeToString(THouseType(GUIBuildIcons[i]-300));
  end;
end;


procedure TKMGamePlayInterface.ShowSettings(Sender: TObject);
begin
  SwitchPage(Sender);
  Settings_Change(nil);
end;

procedure TKMGamePlayInterface.RightClickCancel;
begin
  //This function will be called if the user right clicks on the screen. We should close the build menu if it's open.
  if KMPanel_Build.Visible = true then
    SwitchPage(KMButtonMain[5]);
end;

procedure TKMGamePlayInterface.ShowLoad(Sender: TObject);
//var i:integer;
begin
{for i:=1 to SAVEGAME_COUNT do
  if CheckSaveGameValidity(i) then begin
    KMButton_Save[i].Caption:=Savegame.Title+Savegame.Time;
    KMButton_Load[i].Caption:=Savegame.Title+Savegame.Time;
  end;}
  SwitchPage(Sender);
end;


procedure TKMGamePlayInterface.ShowHouseInfo(Sender:TKMHouse);
const LineAdv = 25; //Each new Line is placed ## pixels after previous
var i,RowRes,Base,Line:integer;
begin
  ShownUnit:=nil;
  ShownHouse:=Sender;
  
  if Sender=nil then begin
    SwitchPage(nil);
    exit;
  end;

  {Common data}
  KMLabel_House.Caption:=TypeToString(Sender.GetHouseType);
  KMImage_House_Logo.TexID:=300+byte(Sender.GetHouseType);
  KMImage_House_Worker.TexID:=140+HouseDAT[byte(Sender.GetHouseType)].OwnerType+1;
  KMImage_House_Worker.Enabled := Sender.GetHasOwner;
  KMImage_House_Worker.Hint := TypeToString(TUnitType(HouseDAT[byte(Sender.GetHouseType)].OwnerType+1));
  KMImage_House_Worker.Visible := TUnitType(HouseDAT[byte(Sender.GetHouseType)].OwnerType+1) <> ut_None;
  if (HouseInput[byte(Sender.GetHouseType)][1] in [rt_None,rt_All,rt_Warfare]) then
    KMButton_House_Goods.Enabled:=false else KMButton_House_Goods.Enable;
  if Sender.BuildingRepair then KMButton_House_Repair.TexID:=39 else KMButton_House_Repair.TexID:=40;
  if Sender.WareDelivery then KMButton_House_Goods.TexID:=37 else KMButton_House_Goods.TexID:=38;
  KMHealthBar_House.Caption:=inttostr(round(Sender.GetHealth))+'/'+inttostr(HouseDAT[byte(Sender.GetHouseType)].MaxHealth);
  KMHealthBar_House.Position:=round( Sender.GetHealth / HouseDAT[byte(Sender.GetHouseType)].MaxHealth * 100 );
  SwitchPage(KMPanel_House);

  case Sender.GetHouseType of
  ht_Store: begin
        StoreFill(nil);
        SwitchPage(KMPanel_HouseStore);
      end;

  ht_School: begin
        KMResRow_School_Resource.ResourceCount:=Sender.CheckResIn(rt_Gold);
        House_SchoolUnitChange(nil);
        SwitchPage(KMPanel_House_School);
      end;

  ht_Barracks: begin
        BarracksFill(nil);
        SwitchPage(KMPanel_HouseBarracks);
        end;
  ht_TownHall:;

  else begin

        //First thing - hide everything
        for i:=1 to KMPanel_House_Common.ChildCount do
          KMPanel_House_Common.Childs[i].Hide;

        //Now show only what we need
        RowRes:=1; Line:=0; Base:=KMPanel_House_Common.Top+2;
        //Show Demand
        if HouseInput[byte(Sender.GetHouseType),1] in [rt_Trunk..rt_Fish] then begin
          KMLabel_Common_Demand.Show;
          KMLabel_Common_Demand.Top:=Base+Line*LineAdv+6;
          inc(Line);
          for i:=1 to 4 do if HouseInput[byte(Sender.GetHouseType),i] in [rt_Trunk..rt_Fish] then begin
            KMRow_Common_Resource[RowRes].Resource:=HouseInput[byte(Sender.GetHouseType),i];
            KMRow_Common_Resource[RowRes].Hint:=TypeToString(HouseInput[byte(Sender.GetHouseType),i]);
            KMRow_Common_Resource[RowRes].ResourceCount:=Sender.CheckResIn(HouseInput[byte(Sender.GetHouseType),i]);
            KMRow_Common_Resource[RowRes].Show;
            KMRow_Common_Resource[RowRes].Top:=Base+Line*LineAdv;
            inc(Line);
            inc(RowRes);
          end;
        end;
        //Show Output
        if not HousePlaceOrders[byte(Sender.GetHouseType)] then
        if HouseOutput[byte(Sender.GetHouseType),1] in [rt_Trunk..rt_Fish] then begin
          KMLabel_Common_Offer.Show;
          KMLabel_Common_Offer.Caption:=fTextLibrary.GetTextString(229)+'(x'+inttostr(HouseDAT[byte(Sender.GetHouseType)].ResProductionX)+'):';
          KMLabel_Common_Offer.Top:=Base+Line*LineAdv+6;
          inc(Line);
          for i:=1 to 4 do
          if HouseOutput[byte(Sender.GetHouseType),i] in [rt_Trunk..rt_Fish] then begin
            KMRow_Common_Resource[RowRes].Resource:=HouseOutput[byte(Sender.GetHouseType),i];
            KMRow_Common_Resource[RowRes].ResourceCount:=Sender.CheckResOut(HouseOutput[byte(Sender.GetHouseType),i]);
            KMRow_Common_Resource[RowRes].Show;
            KMRow_Common_Resource[RowRes].Top:=Base+Line*LineAdv;
            KMRow_Common_Resource[RowRes].Hint:=TypeToString(HouseOutput[byte(Sender.GetHouseType),i]);
            inc(Line);
            inc(RowRes);
          end;
        end;
        //Show Orders
        if HousePlaceOrders[byte(Sender.GetHouseType)] then begin
          KMLabel_Common_Offer.Show;
          KMLabel_Common_Offer.Caption:=fTextLibrary.GetTextString(229)+'(x'+inttostr(HouseDAT[byte(Sender.GetHouseType)].ResProductionX)+'):';
          KMLabel_Common_Offer.Top:=Base+Line*LineAdv+6;
          inc(Line);
          for i:=1 to 4 do //Orders
          if HouseOutput[byte(Sender.GetHouseType),i] in [rt_Trunk..rt_Fish] then begin
            KMRow_Order[i].Resource:=HouseOutput[byte(Sender.GetHouseType),i];
            KMRow_Order[i].ResourceCount:=Sender.CheckResOut(HouseOutput[byte(Sender.GetHouseType),i]);
            KMRow_Order[i].OrderCount:=Sender.CheckResOrder(i);
            KMRow_Order[i].Show;
            KMRow_Order[i].OrderAdd.Show;
            KMRow_Order[i].OrderRem.Show;
            KMRow_Order[i].Hint:=TypeToString(HouseOutput[byte(Sender.GetHouseType),i]);
            KMRow_Order[i].Top:=Base+Line*LineAdv;
            inc(Line);
          end;
          KMLabel_Common_Costs.Show;
          KMLabel_Common_Costs.Top:=Base+Line*LineAdv+6;
          inc(Line);
          for i:=1 to 4 do //Costs
          if HouseOutput[byte(Sender.GetHouseType),i] in [rt_Trunk..rt_Fish] then begin
            KMRow_Costs[i].CostID:=byte(HouseOutput[byte(Sender.GetHouseType),i]);
            KMRow_Costs[i].Show;
            KMRow_Costs[i].Top:=Base+Line*LineAdv;
            inc(Line);
          end;

        end;
      SwitchPage(KMPanel_House_Common);
      end;
  end;
end;


procedure TKMGamePlayInterface.ShowUnitInfo(Sender:TKMUnit);
begin
  ShownUnit:=Sender;
  ShownHouse:=nil;
  if (Sender=nil)or(not Sender.IsVisible)or((Sender<>nil)and(Sender.ScheduleForRemoval)) then begin
    SwitchPage(nil);
    exit;
  end;
  SwitchPage(KMPanel_Unit);
  KMLabel_UnitName.Caption:=TypeToString(Sender.GetUnitType);
  KMImage_UnitPic.TexID:=520+byte(Sender.GetUnitType);
  KMConditionBar_Unit.Position:=EnsureRange(round(Sender.GetCondition / UNIT_MAX_CONDITION * 100),-10,110);
  //@Krom: No string in LIB files availible.
  //If this is perminate (not just debugging) then we will need to add it.
  //Prehaps we should start a list of new texts added which will need translating?
  //@Lewin: This is for debug atm, but I think this could be a nice new feature.
  //Yes, can you make a sort of extension to LoadLIB? > See LoadLib for my comments.
  KMLabel_UnitTask.Caption:='Task: '+Sender.GetUnitTaskText;
  KMLabel_UnitDescription.Caption := fTextLibrary.GetTextString(siUnitDescriptions+byte(Sender.GetUnitType))
end;


procedure TKMGamePlayInterface.House_RepairToggle(Sender:TObject);
begin
  if fPlayers.SelectedHouse = nil then exit;
  with fPlayers.SelectedHouse do begin
    BuildingRepair := not BuildingRepair;
    if BuildingRepair then fGamePlayInterface.KMButton_House_Repair.TexID:=39
                      else fGamePlayInterface.KMButton_House_Repair.TexID:=40;
  end;
end;


procedure TKMGamePlayInterface.House_WareDeliveryToggle(Sender:TObject);
begin
  if fPlayers.SelectedHouse = nil then exit;
  with fPlayers.SelectedHouse do begin
    WareDelivery := not WareDelivery;
    if WareDelivery then fGamePlayInterface.KMButton_House_Goods.TexID:=37
                    else fGamePlayInterface.KMButton_House_Goods.TexID:=38;
    end;
end;


procedure TKMGamePlayInterface.House_OrderClick(Sender:TObject);
var i:integer;
begin
  for i:=1 to 4 do begin
    if Sender = KMRow_Order[i].OrderRem then fPlayers.SelectedHouse.RemOrder(i);
    if Sender = KMRow_Order[i].OrderAdd then fPlayers.SelectedHouse.AddOrder(i);
  end;
end;


procedure TKMGamePlayInterface.House_OrderClickRight(Sender:TObject);
var i:integer;
begin
  for i:=1 to 4 do begin
    if Sender = KMRow_Order[i].OrderRem then fPlayers.SelectedHouse.RemOrder(i,10);
    if Sender = KMRow_Order[i].OrderAdd then fPlayers.SelectedHouse.AddOrder(i,10);
  end;
end;


{Process click on Left-Train-Right buttons of School}
procedure TKMGamePlayInterface.House_SchoolUnitChange(Sender:TObject);
var i:byte; School:TKMHouseSchool;
begin
  School:=TKMHouseSchool(fPlayers.SelectedHouse);

  if (Sender=KMButton_School_Left)and(LastSchoolUnit > 1) then dec(LastSchoolUnit);
  if (Sender=KMButton_School_Right)and(LastSchoolUnit < length(School_Order)) then inc(LastSchoolUnit);

  if Sender=KMButton_School_Train then //Add unit to training queue
    School.AddUnitToQueue(TUnitType(School_Order[LastSchoolUnit]));

  if School.UnitQueue[1]<>ut_None then
    KMButton_School_UnitWIP.TexID :=140+byte(School.UnitQueue[1])
  else
    KMButton_School_UnitWIP.TexID :=41; //Question mark

  KMButton_School_UnitWIPBar.Position:=School.UnitTrainProgress;

  for i:=1 to 5 do
    if School.UnitQueue[i+1]<>ut_None then
    begin
      KMButton_School_UnitPlan[i].TexID:=140+byte(School.UnitQueue[i+1]);
      KMButton_School_UnitPlan[i].Hint:=TypeToString(School.UnitQueue[i+1]);
    end
    else
    begin
      KMButton_School_UnitPlan[i].TexID:=0;
      KMButton_School_UnitPlan[i].Hint:='';
    end;

  KMButton_School_Left.Enabled := LastSchoolUnit > 1;
  KMButton_School_Right.Enabled := LastSchoolUnit < length(School_Order);
  KMImage_School_Left.Visible:= KMButton_School_Left.Enabled;
  KMImage_School_Right.Visible:= KMButton_School_Right.Enabled;

  if KMButton_School_Left.Enabled then
    KMImage_School_Left.TexID:=520+byte(School_Order[LastSchoolUnit-1]);

  KMLabel_School_Unit.Caption:=TypeToString(TUnitType(School_Order[LastSchoolUnit]));
  KMImage_School_Train.TexID:=520+byte(School_Order[LastSchoolUnit]);

  if KMButton_School_Right.Enabled then
    KMImage_School_Right.TexID:=520+byte(School_Order[LastSchoolUnit+1]);
end;


{Process right click on Left-Right buttons of School}
procedure TKMGamePlayInterface.House_SchoolUnitChangeRight(Sender:TObject);
begin
  if Sender=KMButton_School_Left then LastSchoolUnit := 1;
  if Sender=KMButton_School_Right then LastSchoolUnit := Length(School_Order);
  House_SchoolUnitChange(nil);
end;


{Process click on Remove-from-queue buttons of School}
procedure TKMGamePlayInterface.House_SchoolUnitRemove(Sender:TObject);
var i:integer;
begin
  if Sender = KMButton_School_UnitWIP then
    TKMHouseSchool(fPlayers.SelectedHouse).RemUnitFromQueue(1)
  else for i:=1 to 5 do
    if Sender = KMButton_School_UnitPlan[i] then
      TKMHouseSchool(fPlayers.SelectedHouse).RemUnitFromQueue(i+1);
  House_SchoolUnitChange(nil);
end;


{That small red triangle blocking delivery of goods to Storehouse}
{Resource determined by Button.Tag property}
procedure TKMGamePlayInterface.House_StoreAcceptFlag(Sender:TObject);
begin
  TKMHouseStore(fPlayers.SelectedHouse).NotAcceptFlag[(Sender as TKMControl).Tag]:=
    not TKMHouseStore(fPlayers.SelectedHouse).NotAcceptFlag[(Sender as TKMControl).Tag];
end;


procedure TKMGamePlayInterface.Settings_Change(Sender:TObject);
begin
  if Sender = KMButton_Settings_Dark then fGameSettings.DecBrightness;
  if Sender = KMButton_Settings_Light then fGameSettings.IncBrightness;
  if Sender = KMLabel_Settings_Autosave then fGameSettings.IsAutosave:=not fGameSettings.IsAutosave;
  if Sender = KMLabel_Settings_FastScroll then fGameSettings.IsFastScroll:=not fGameSettings.IsFastScroll;
  if Sender = KMRatio_Settings_Mouse then fGameSettings.SetMouseSpeed(KMRatio_Settings_Mouse.Position);
  if Sender = KMRatio_Settings_SFX then fGameSettings.SetSoundFXVolume(KMRatio_Settings_SFX.Position);
  if Sender = KMRatio_Settings_Music then fGameSettings.SetMusicVolume(KMRatio_Settings_Music.Position);
  if Sender = KMButton_Settings_Music then fGameSettings.IsMusic:=not fGameSettings.IsMusic;
  KMLabel_Settings_BrightValue.Caption:=fTextLibrary.GetTextString(185 + fGameSettings.GetBrightness);
  if fGameSettings.IsAutosave then
  KMLabel_Settings_Autosave.Caption:='X '+fTextLibrary.GetTextString(203)
  else
  KMLabel_Settings_Autosave.Caption:='O '+fTextLibrary.GetTextString(203);
  if fGameSettings.IsFastScroll then
  KMLabel_Settings_FastScroll.Caption:='X '+fTextLibrary.GetTextString(204)
  else
  KMLabel_Settings_FastScroll.Caption:='O '+fTextLibrary.GetTextString(204);
  KMRatio_Settings_Mouse.Position:=fGameSettings.GetMouseSpeed;
  KMRatio_Settings_SFX.Position:=fGameSettings.GetSoundFXVolume;
  KMRatio_Settings_Music.Position:=fGameSettings.GetMusicVolume;
  if fGameSettings.IsMusic then
  KMButton_Settings_Music.Caption:=fTextLibrary.GetTextString(201) else KMButton_Settings_Music.Caption:=fTextLibrary.GetTextString(199);
end;


{Quit the mission and return to main menu}
procedure TKMGamePlayInterface.QuitMission(Sender:TObject);
var i:integer;
begin
  KMPanel_Main.Hide;
  for i:=1 to KMPanel_Main.ChildCount do
    if KMPanel_Main.Childs[i] is TKMPanel then
      KMPanel_Main.Childs[i].Hide;

  fGame.StopGame();
end;


{Virtually press BuildRoad button when changing page to BuildingPage or after house plan is placed}
procedure TKMGamePlayInterface.SelectRoad;
begin
  BuildButtonClick(KMButton_BuildRoad);
end;


procedure TKMGamePlayInterface.Build_Fill(Sender:TObject);
var i:integer;
begin
  for i:=1 to HOUSE_COUNT do
  if MyPlayer.GetCanBuild(THouseType(GUIBuildIcons[i]-300)) then begin
    KMButton_Build[i].Enable;
    KMButton_Build[i].TexID:=GUIBuildIcons[i];
    KMButton_Build[i].OnClick:=BuildButtonClick;      
    KMButton_Build[i].Hint:=TypeToString(THouseType(GUIBuildIcons[i]-300));
  end else begin
    KMButton_Build[i].OnClick:=nil;
    KMButton_Build[i].TexID:=41;
    KMButton_Build[i].Hint:=fTextLibrary.GetTextString(251); //Building not available
  end;
end;


procedure TKMGamePlayInterface.StoreFill(Sender:TObject);
var i,Tmp:integer;
begin
  if fPlayers.SelectedHouse=nil then exit;
  for i:=1 to 28 do begin
    Tmp:=TKMHouseStore(fPlayers.SelectedHouse).ResourceCount[i];
    if Tmp=0 then KMButton_Store[i].Caption:='-'
             else KMButton_Store[i].Caption:=inttostr(Tmp);
    KMImage_Store_Accept[i].Visible := TKMHouseStore(fPlayers.SelectedHouse).NotAcceptFlag[i];
  end;
end;


procedure TKMGamePlayInterface.BarracksFill(Sender:TObject);
var i,Tmp:integer;
begin
  for i:=1 to 11 do begin
    Tmp:=TKMHouseBarracks(fPlayers.SelectedHouse).ResourceCount[i];
    if Tmp=0 then KMButton_Barracks[i].Caption:='-'
             else KMButton_Barracks[i].Caption:=inttostr(Tmp);
  end;
    Tmp:=TKMHouseBarracks(fPlayers.SelectedHouse).RecruitsInside;
    if Tmp=0 then KMButton_Barracks[12].Caption:='-'
             else KMButton_Barracks[12].Caption:=inttostr(Tmp);
end;


procedure TKMGamePlayInterface.Stats_Fill(Sender:TObject);
var i,k,ci,Tmp:integer;
begin
  ci:=0;
  for i:=1 to 11 do for k:=1 to 4 do
  if StatHouseOrder[i,k]<>ht_None then begin
    inc(ci);
    Tmp:=MyPlayer.GetHouseQty(StatHouseOrder[i,k]);
    if Tmp=0 then Stat_HouseQty[ci].Caption:='-' else Stat_HouseQty[ci].Caption:=inttostr(Tmp);
    if MyPlayer.GetCanBuild(StatHouseOrder[i,k]) or (Tmp>0) then
    begin
      Stat_House[ci].TexID:=byte(StatHouseOrder[i,k])+300;
      Stat_House[ci].Hint:=TypeToString(StatHouseOrder[i,k]);
      Stat_HouseQty[ci].Hint:=TypeToString(StatHouseOrder[i,k]);
    end
    else
    begin
      Stat_House[ci].TexID:=41;
      Stat_House[ci].Hint:=fTextLibrary.GetTextString(251); //Building not available
      Stat_HouseQty[ci].Hint:=fTextLibrary.GetTextString(251); //Building not available
    end;
  end;
  ci:=0;
  for i:=1 to 11 do for k:=1 to 5 do
  if StatUnitOrder[i,k]<>ut_None then begin
    inc(ci);
    Tmp:=MyPlayer.GetUnitQty(StatUnitOrder[i,k]);
    if Tmp=0 then Stat_UnitQty[ci].Caption:='-' else Stat_UnitQty[ci].Caption:=inttostr(Tmp);
    Stat_Unit[ci].Hint:=TypeToString(StatUnitOrder[i,k]);
    Stat_UnitQty[ci].Hint:=TypeToString(StatUnitOrder[i,k]);
  end;
end;

procedure TKMGamePlayInterface.SetHintEvents(AHintEvent:TMouseMoveEvent);
var
  i: integer;
begin
  //Here we must go through every control and set the hint event to be the parameter
  for i:=0 to MyControls.Count-1 do
    if MyControls.Items[i] <> nil then
      TKMControl(MyControls.Items[i]).OnHint := AHintEvent;
end;

procedure TKMGamePlayInterface.EnableOrDisableMenuIcons;
begin
  if MissionMode = mm_Tactic then
  begin
    KMButtonMain[1].Enabled := false;
    KMButtonMain[2].Enabled := false;
    KMButtonMain[3].Enabled := false;
  end
  else
  begin
    KMButtonMain[1].Enabled := true;
    KMButtonMain[2].Enabled := true;
    KMButtonMain[3].Enabled := true;
  end;
end;

end.
