unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, TeEngine, TeeFunci, Series,
  TeeProcs, Chart;

type
  TMainForm = class(TForm)
    LogoImage: TImage;
    LogoBevel: TBevel;
    ExitButton: TButton;
    ExitBevel: TBevel;
    MainPanel: TPanel;
    AccassGroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    PhComboBox: TComboBox;
    LogComboBox: TComboBox;
    CompetentionGroupBox: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    CiqComboBox: TComboBox;
    CsysComboBox: TComboBox;
    ArmorGroupBox: TGroupBox;
    ArmorComboBox: TComboBox;
    MotivGroupBox: TGroupBox;
    MotivComboBox: TComboBox;
    StatusBar: TStatusBar;
    CompetenceChart: TChart;
    CSeries: TBarSeries;
    AddTeeFunction3: TAddTeeFunction;
    ArmorChart: TChart;
    ArmorSeries: TBarSeries;
    AddTeeFunction1: TAddTeeFunction;
    MotivationChart: TChart;
    MotivationSeries: TBarSeries;
    AddTeeFunction2: TAddTeeFunction;
    PotentialChart: TChart;
    PotentialSeries: TBarSeries;
    AddTeeFunction4: TAddTeeFunction;
    Logo_1: TLabel;
    Logo_4: TLabel;
    CopyrightLabel_2: TLabel;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PhComboBoxChange(Sender: TObject);
    procedure LogComboBoxChange(Sender: TObject);
    procedure CiqComboBoxChange(Sender: TObject);
    procedure CsysComboBoxChange(Sender: TObject);
    procedure ArmorComboBoxChange(Sender: TObject);
    procedure MotivComboBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

const

  CiqHigh    = 5;
  CiqMiddle  = 2;
  CiqLow     = 0;

  CsysHigh   = 5;
  CsysMiddle = 2;
  CsysLow    = 0;

  CHigh      = 5;
  CMiddle    = 2;
  CLow       = 0;

  ANo        = 0;
  AStd       = 1;
  ASpec      = 3;
  AOrd       = 5;

  MHigh      = 5;
  MBase      = 2;
  MNo        = 0;
  
function GetIQCompetence : integer;
begin
  case MainForm.CiqComboBox.ItemIndex of
    0 : Result := CiqHigh;
    1 : Result := CiqMiddle;
    2 : Result := CiqLow;
  end;
end;

function GetSysCompetence : integer;
begin
  case MainForm.CsysComboBox.ItemIndex of
    0 : Result := CsysHigh;
    1 : Result := CsysMiddle;
    2 : Result := CsysLow;
  end;
end;

function GetCompetence : integer;
begin
  if (GetIQCompetence + GetSysCompetence) > 5 then Result := CHigh;
  if ((GetIQCompetence + GetSysCompetence) < 6) and
    ((GetIQCompetence + GetSysCompetence) > 2) then Result := CMiddle;
  if (GetIQCompetence + GetSysCompetence) < 3 then Result := CLow;
end;

function GetArmor : integer;
begin
  case MainForm.ArmorComboBox.ItemIndex of
    0 : Result := AStd;
    1 : Result := ASpec;
    2 : Result := AOrd;
    3 : Result := ANo;
  end;
end;

function GetMotivation : integer;
begin
  case MainForm.MotivComboBox.ItemIndex of
    0 : Result := MHigh;
    1 : Result := MBase;
    2 : Result := MNo;
  end;
end;

function GetPhLevelStr : string;
begin
  case MainForm.PhComboBox.ItemIndex of
    0 : Result := 'In';
    1 : Result := 'Out';
  end;
end;

function GetLogicalLevelStr : string;
begin
  case MainForm.LogComboBox.ItemIndex of
    0 : Result := 'L0';
    1 : Result := 'L1';
    2 : Result := 'L2';
    3 : Result := 'L3';
  end;
end;

function GetCompetenceStr : string;
begin
  case GetCompetence of
    CHigh   : Result := 'H';
    CMiddle : Result := 'M';
    CLow    : Result := 'L';
  end;
end;

function GetArmorStr : string;
begin
  case GetArmor of
    AStd  : Result := 'St';
    ASpec : Result := 'Sp';
    AOrd  : Result := 'Ord';
    ANo   : Result := 'N';
  end;
end;

function GetMotiveStr : string;
begin
  case MainForm.MotivComboBox.ItemIndex of
    0 : Result := 'H';
    1 : Result := 'M';
    2 : Result := 'N';
  end;
end;

function GetPrelBasePotential : string;
begin
  if (GetCompetence + GetArmor) > 7 then Result := 'H';
  if ((GetCompetence + GetArmor) < 8) and
   ((GetCompetence + GetArmor) > 4) then Result := 'M';
  if ((GetCompetence + GetArmor) < 5) and
   ((GetCompetence + GetArmor) > 2) then Result := 'L';
  if (GetCompetence + GetArmor) < 3 then Result := 'N';
end;

function GetBasePotentialNoMotive : string;
begin
  if GetLogicalLevelStr = 'L0' then Result := GetPrelBasePotential;
  if GetLogicalLevelStr = 'L1' then Result := GetPrelBasePotential;
  if GetLogicalLevelStr = 'L2' then
    begin
      if GetPrelBasePotential = 'N' then Result := 'L';
      if GetPrelBasePotential = 'L' then Result := 'M';
      if GetPrelBasePotential = 'M' then Result := 'H';
      if GetPrelBasePotential = 'H' then Result := 'H';
    end;
  if GetLogicalLevelStr ='L3' then
    begin
      if GetPrelBasePotential = 'N' then Result := 'L';
      if GetPrelBasePotential = 'L' then Result := 'M';
      if GetPrelBasePotential = 'M' then Result := 'H';
      if GetPrelBasePotential = 'H' then Result := 'H';
    end;
end;

function GetBasePotentialStr : string;
begin
  if GetMotiveStr = 'H' then
    begin
      if GetBasePotentialNoMotive = 'N' then
        Result := 'Îòñóòñòâóåò';
      if GetBasePotentialNoMotive = 'L' then
        Result := 'Ñðåäíèé';
      if GetBasePotentialNoMotive = 'M' then
        Result := 'Âûñîêèé';
      if GetBasePotentialNoMotive = 'H' then
        Result := 'Âûñîêèé';
    end;
  if GetMotiveStr = 'M' then
    begin
      if GetBasePotentialNoMotive = 'N' then
        Result := 'Îòñóòñòâóåò';
      if GetBasePotentialNoMotive = 'L' then
        Result := 'Íèçêèé';
      if GetBasePotentialNoMotive = 'M' then
        Result := 'Ñðåäíèé';
      if GetBasePotentialNoMotive = 'H' then
        Result := 'Âûñîêèé';
    end;
  if GetMotiveStr = 'N' then
    begin
      if GetBasePotentialNoMotive = 'N' then
        Result := 'Îòñóòñòâóåò';
      if GetBasePotentialNoMotive = 'L' then
        Result := 'Íèçêèé';
      if GetBasePotentialNoMotive = 'M' then
        Result := 'Íèçêèé';
      if GetBasePotentialNoMotive = 'H' then
        Result := 'Íèçêèé';
    end;
end;

function GetBasePotential : integer;
begin
  if GetBasePotentialStr = 'Îòñóòñòâóåò' then Result := 0;
  if GetBasePotentialStr = 'Íèçêèé' then Result := 1;
  if GetBasePotentialStr = 'Ñðåäíèé' then Result := 3;
  if GetBasePotentialStr = 'Âûñîêèé' then Result := 5;
end;

function GetBasePotentialString : string;
begin
  Result := 'PhL:' + GetPhLevelStr +
            '/LogL:' + GetlogicalLevelStr +
            '/C:' + GetCompetenceStr +
            '/A:' + GetArmorStr+
            '/M:' + GetMotiveStr;
end;

function GetColorSeries(Value : integer) : TColor;
begin
  case Value of
    0..1 : Result := clLime;
    2..4 : Result := clBlue;
       5 : Result := clRed;
  end;
end;

procedure DataRefresh;
begin
  MainForm.StatusBar.Panels.Items[1].Text := GetBasePotentialStr;
  MainForm.StatusBar.Panels.Items[3].Text := GetBasePotentialString;
  MainForm.CSeries.Clear;
  MainForm.CSeries.Add(GetIQCompetence, 'IQ',
    GetColorSeries(GetIQCompetence));
  MainForm.CSeries.Add(GetSysCompetence, 'Sys',
    GetColorSeries(GetSysCompetence));
  MainForm.ArmorSeries.Clear;
  MainForm.ArmorSeries.Add(GetArmor, 'A',
    GetColorSeries(GetArmor));
  MainForm.MotivationSeries.Clear;
  MainForm.MotivationSeries.Add(GetMotivation, 'M',
    GetColorSeries(GetMotivation));
  MainForm.PotentialSeries.Clear;
  MainForm.PotentialSeries.Add(GetBasePotential, 'P',
    GetColorSeries(GetBasePotential));
end;

procedure TMainForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 DataRefresh;
end;

procedure TMainForm.PhComboBoxChange(Sender: TObject);
begin
  DataRefresh;
end;

procedure TMainForm.LogComboBoxChange(Sender: TObject);
begin
  DataRefresh;
end;

procedure TMainForm.CiqComboBoxChange(Sender: TObject);
begin
  DataRefresh;
end;

procedure TMainForm.CsysComboBoxChange(Sender: TObject);
begin
  DataRefresh;
end;

procedure TMainForm.ArmorComboBoxChange(Sender: TObject);
begin
  DataRefresh;
end;

procedure TMainForm.MotivComboBoxChange(Sender: TObject);
begin
  DataRefresh;
end;

end.
