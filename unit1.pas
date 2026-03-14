unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
  private
    ColorIndex: Integer;
    procedure UpdateColor;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  BorderStyle := bsNone;
  WindowState := wsMaximized;
  KeyPreview := True;

  ColorIndex := 0;
  UpdateColor;
end;

procedure TForm1.UpdateColor;
begin
  case ColorIndex of
    0: Color := clBlack;
    1: Color := clWhite;
    2: Color := clRed;
    3: Color := clBlue;
    4: Color := clGreen;
    5: Color := RGBToColor(128,128,128); // Best screen defect detection color
    6: Color := clLime;
    7,8,9,10: Color := clBlack; // Checkerboards use black background
  end;

  Invalidate;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  x, y: Integer;
  cols, rows: Integer;
  cellW, cellH: Integer;
  invert: Boolean;
begin
  if (ColorIndex < 7) or (ColorIndex > 10) then
    Exit;

  case ColorIndex of
    7,8:
      begin
        cols := 10;
        rows := 5;
      end;

    9,10:
      begin
        cols := 20;
        rows := 10;
      end;
  end;

  invert := (ColorIndex = 8) or (ColorIndex = 10);

  cellW := Width div cols;
  cellH := Height div rows;

  for y := 0 to rows - 1 do
  for x := 0 to cols - 1 do
  begin
    if ((x + y) mod 2 = 0) xor invert then
      Canvas.Brush.Color := clWhite
    else
      Canvas.Brush.Color := clBlack;

    Canvas.FillRect(
      x * cellW,
      y * cellH,
      (x + 1) * cellW,
      (y + 1) * cellH
    );
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;

  Inc(ColorIndex);

  if ColorIndex > 10 then
    ColorIndex := 0;

  UpdateColor;
end;

end.
