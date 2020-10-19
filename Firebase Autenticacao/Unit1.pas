unit Unit1;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Actions,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.DateTimeCtrls,
  FMX.ListBox,
  FMX.Layouts,
  FMX.ListView,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.TabControl,
  FMX.ActnList,
  FMX.Effects,
  FMX.ScrollBox,
  FMX.Memo, FMX.Memo.Types;

const
  WEB_API_KEY = '';

type
  TForm1 = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    recFundoLogin: TRectangle;
    lytLogin: TLayout;
    edt_email: TEdit;
    edt_senha: TEdit;
    lblNovo: TLabel;
    TabMain: TTabItem;
    TabRecuperarSenha: TTabItem;
    lblRecuperar: TLabel;
    ActionList1: TActionList;
    MudarTab1: TChangeTabAction;
    MudarTab2: TChangeTabAction;
    TabCriaConta: TTabItem;
    MudarTab3: TChangeTabAction;
    Layout25: TLayout;
    VertScrollBox7: TVertScrollBox;
    Text1: TText;
    lytTop: TLayout;
    MudarTab4: TChangeTabAction;
    lytUser: TLayout;
    Rectangle1: TRectangle;
    Layout5: TLayout;
    Path1: TPath;
    lytPass: TLayout;
    Rectangle3: TRectangle;
    Layout4: TLayout;
    Path2: TPath;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    lytBtnLogin: TLayout;
    recBtnLogin: TRectangle;
    ShadowEffect3: TShadowEffect;
    lblBtnLogin: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    cirMaior: TCircle;
    cirMenor: TCircle;
    lytLogo: TLayout;
    Path3: TPath;
    Layout1: TLayout;
    StyleBook1: TStyleBook;
    Rectangle4: TRectangle;
    lytGeralCad: TLayout;
    lytEdtCadLogin: TLayout;
    Rectangle2: TRectangle;
    ShadowEffect4: TShadowEffect;
    edtCadLogin: TEdit;
    Layout8: TLayout;
    Path4: TPath;
    lytEdtCadPass: TLayout;
    Rectangle5: TRectangle;
    ShadowEffect5: TShadowEffect;
    Layout10: TLayout;
    Path5: TPath;
    edtCadPass: TEdit;
    lytBtnCad: TLayout;
    Rectangle6: TRectangle;
    ShadowEffect6: TShadowEffect;
    Label6: TLabel;
    lblTitCria: TLabel;
    lytBackToLoginFromCria: TLayout;
    Path6: TPath;
    speBackToLoginFromCria: TSpeedButton;
    Rectangle7: TRectangle;
    Layout2: TLayout;
    Layout3: TLayout;
    Path7: TPath;
    SpeedButton2: TSpeedButton;
    Rectangle8: TRectangle;
    Layout6: TLayout;
    Layout7: TLayout;
    Path8: TPath;
    SpeedButton3: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Layout9: TLayout;
    Rectangle9: TRectangle;
    ShadowEffect7: TShadowEffect;
    edtRecuperarSenha: TEdit;
    Layout11: TLayout;
    Path9: TPath;
    Layout12: TLayout;
    Rectangle10: TRectangle;
    ShadowEffect8: TShadowEffect;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure lblNovoClick(Sender: TObject);
    procedure lblRecuperarClick(Sender: TObject);
    procedure recBtnLoginClick(Sender: TObject);
    procedure Rectangle6Click(Sender: TObject);
    procedure speBackToLoginFromCriaClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Rectangle10Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    FToken: string;
    procedure CriarContaFirebase;
    function DoLogin: Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Firebase.Auth,
  Firebase.Interfaces,
  Firebase.Request,
  Firebase.Response,
  System.JSON,
  System.JSON.Writers;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  CriarContaFirebase;
  MudarTab1.ExecuteTarget(Sender);
  ShowMessage('Conta criada com sucesso!');
end;

procedure TForm1.CriarContaFirebase;
var
  Auth         : IFirebaseAuth;
  AResponse    : IFirebaseResponse;
  JSONResp     : TJSONValue;
  Obj          : TJSONObject;
  ObjError     : TJSONObject;
  LToken       : string;
  ErrorCode    : string;
  ErrorMessage : string;
begin
  Auth := TFirebaseAuth.Create;
  Auth.SetApiKey(WEB_API_KEY);
  AResponse := Auth.CreateUserWithEmailAndPassword(edtCadLogin.Text, edtCadPass.Text);
  JSONResp := TJSONObject.ParseJSONValue(AResponse.ContentAsString);
  if (not Assigned(JSONResp)) or (not (JSONResp is TJSONObject)) then
  begin
    if Assigned(JSONResp) then
      JSONResp.Free;
    exit;
  end;

  Obj := JSONResp as TJsonObject;

  //if Obj.TryGetValue('idToken', LToken) then
  //  MemToken.Lines.Add(LToken);

  if Obj.TryGetValue('error', ObjError) then
  begin
    ObjError.TryGetValue('code', ErrorCode);
    ObjError.TryGetValue('message', ErrorMessage);
    if ErrorMessage.Equals('EMAIL_EXISTS') then
      raise Exception.Create('Esse email já existe')
    else if ErrorMessage.Equals('INVALID_EMAIL') then
      raise Exception.Create('E-mail inválido.')
    else if (Pos('WEAK_PASSWORD', ErrorMessage) > 0) then
      raise Exception.Create('Senha fraca: a senha deve conter ao menos 6 caracteres.');
  end;
end;

function TForm1.DoLogin: Boolean;
var
  Auth      : IFirebaseAuth;
  AResponse : IFirebaseResponse;
  JSONResp  : TJSONValue;
  Obj       : TJSONObject;
begin
  Result := False;
  Auth := TFirebaseAuth.Create;
  Auth.SetApiKey(WEB_API_KEY);
  AResponse := Auth.SignInWithEmailAndPassword(edt_email.Text, edt_senha.Text);
  JSONResp := TJsonObject.ParseJSONValue(AResponse.ContentAsString());
  try
    if (not Assigned(JSONResp)) or (not (JSONResp is TJSONObject)) then
      Exit(False);

    Obj := JSONResp as TJSONObject;
    Result := Obj.TryGetValue('idToken', FToken);
  finally
    JSONResp.DisposeOf;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TabControl.ActiveTab   := TabLogin;
  TabControl.TabPosition := TTabPosition.None;
end;

procedure TForm1.lblNovoClick(Sender: TObject);
begin
  MudarTab3.ExecuteTarget(Sender);
end;

procedure TForm1.lblRecuperarClick(Sender: TObject);
begin
  MudarTab2.ExecuteTarget(Sender);
end;

procedure TForm1.recBtnLoginClick(Sender: TObject);
begin
  if not DoLogin then
  begin
    ShowMessage('Não possui conta. E-mail ou senha inválida!');
    exit;
  end;
  MudarTab1.ExecuteTarget(Sender);
end;

procedure TForm1.Rectangle10Click(Sender: TObject);
var
  Auth         : IFirebaseAuth;
  AResponse    : IFirebaseResponse;
  JSONResp     : TJSONValue;
  Obj          : TJSONObject;
begin
  if edtRecuperarSenha.Text.Equals(EmptyStr) then
  begin
    ShowMessage('Informe o email');
    exit;
  end;

  Auth := TFirebaseAuth.Create;
  Auth.SetApiKey(WEB_API_KEY);
  AResponse := Auth.SendResetPassword(edtRecuperarSenha.Text);
  JSONResp := TJsonObject.ParseJSONValue(AResponse.ContentAsString());
  (* Se desejar fazer algum tipo de teste
  if (not Assigned(JSONResp)) or (not (JSONResp is TJSONObject)) then
  begin
    if Assigned(JSONResp) then
      JSONResp.Free;
    exit;
  end;
  *)
  ShowMessage('Cadastro efetuado com sucesso.');
  edtRecuperarSenha.Text := EmptyStr;
  MudarTab1.Tab := TabLogin;
  MudarTab1.ExecuteTarget(Sender)
end;

procedure TForm1.Rectangle6Click(Sender: TObject);
begin
  if edtCadLogin.Text.IsEmpty then
  begin
    ShowMessage('Digite um endereço de email.');
    edtCadLogin.SetFocus;
    exit;
  end;

  if edtCadPass.Text.IsEmpty then
  begin
    ShowMessage('Digite uma senha.');
    edtCadPass.SetFocus;
    exit;
  end;

  CriarContaFirebase;
  MudarTab1.ExecuteTarget(Sender);
  ShowMessage('Conta criada com sucesso!');
end;

procedure TForm1.speBackToLoginFromCriaClick(Sender: TObject);
begin
  MudarTab1.Tab := TabLogin;
  MudarTab1.ExecuteTarget(Sender);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  MudarTab1.Tab := TabLogin;
  MudarTab1.ExecuteTarget(Sender);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  MudarTab1.Tab := TabLogin;
  MudarTab1.ExecuteTarget(Sender);
end;

end.
