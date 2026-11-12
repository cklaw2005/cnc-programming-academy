param(
  [string]$OutputDirectory = (Join-Path $PSScriptRoot 'standalone'),
  [int]$FramesPerSecond = 12
)

$ErrorActionPreference = 'Stop'
$ffmpeg = (Get-Command ffmpeg -ErrorAction Stop).Source
$ffprobe = (Get-Command ffprobe -ErrorAction Stop).Source
Add-Type -AssemblyName System.Speech
Add-Type -AssemblyName System.Drawing

$temp = Join-Path $OutputDirectory '_render'
New-Item -ItemType Directory -Force -Path $OutputDirectory, $temp | Out-Null

$scenes = @(
  @{ title='CNC PROGRAMMING ESSENTIALS'; label='A visual introduction to machine motion'; code='PROGRAM  →  CONTROL  →  TOOLPATH'; mode='intro'; narration='A CNC program is a set of instructions interpreted by a machine control. This short lesson connects coordinates, motion commands, machining, and inspection. Examples are educational only.' },
  @{ title='01  ·  COORDINATES & DATUMS'; label='The control needs a known reference'; code='X  →  left / right     Y  →  in / out     Z  →  up / down'; mode='axes'; narration='Every programmed position depends on an axis convention and a datum. Machine zero is established by the machine; a work offset such as G54 relates program coordinates to the setup part.' },
  @{ title='02  ·  G90 & G91'; label='Absolute targets versus relative steps'; code='G90  X60  →  target at 60\nG91  X10  →  move 10 from here'; mode='modes'; narration='G90 reads coordinates as positions from the active origin. G91 reads them as movements from the current position. Confirm the active mode before every move; a mistaken modal assumption can send the tool somewhere unexpected.' },
  @{ title='03  ·  G00 RAPID'; label='Positioning motion — clearance matters'; code='G00 X40 Y20'; mode='rapid'; narration='G00 requests rapid positioning. The control moves axes at machine-defined rapid rates; the exact path may vary by control. Rapid is not a cutting feed. Keep the route clear of stock, clamps, and fixtures.' },
  @{ title='04  ·  G01 LINEAR FEED'; label='A straight, controlled cutting move'; code='G01 X60 Y20 F250'; mode='linear'; narration='G01 commands linear interpolation at the programmed feed. The control coordinates the axes so the tool follows a straight path. A missing or stale feed, wrong units, or wrong feed mode can damage a tool or part.' },
  @{ title='05  ·  G02 & G03 ARCS'; label='Circular interpolation in a selected plane'; code='G17  ·  XY plane\nG02  ·  clockwise       G03  ·  counterclockwise'; mode='arc'; narration='G02 and G03 request clockwise or counterclockwise circular motion in the active plane. Endpoints and arc-center or radius data follow the selected controller convention. Verify the plane, center, and direction in a backplot.' },
  @{ title='06  ·  M-CODES'; label='Auxiliary machine actions'; code='M03 / M04  spindle     M05  stop\nM08 / M09  coolant      M30  end'; mode='mcodes'; narration='M-codes request machine actions such as spindle rotation, stop, coolant, and program end. Their exact behavior can depend on the machine builder. Confirm direction, speed limits, coolant function, and safe restart procedure.' },
  @{ title='07  ·  TURNING & MILLING'; label='Different machines, different workholding'; code='LATHE  ·  rotating workpiece\nMILL  ·  rotating cutter'; mode='process'; narration='On a lathe the workpiece usually rotates as the tool feeds along its profile. On a mill the cutter rotates while the workpiece is held. Facing, turning, boring, slots, and pockets each need suitable tooling and clearance.' },
  @{ title='08  ·  AUTOMOTIVE QUALITY'; label='Control dimensions with measurement evidence'; code='TOOL WEAR  →  DIMENSION TREND  →  CONTROLLED ACTION'; mode='quality'; narration='In automotive production, tool wear can shift a shaft or bearing-seat diameter over time. Track measurements in sequence, verify the measurement system, and follow the control plan. Cpk is meaningful only when the process is stable and the data are suitable.' },
  @{ title='09  ·  SAFE PROVE-OUT'; label='Simulate, inspect, then follow local procedure'; code='CHECK MODES  ·  OFFSETS  ·  CLEARANCE  ·  TOOLING'; mode='safety'; narration='Before real machining, verify the exact controller manual, program, offsets, tool assembly, workholding, and clearance. Use the approved prove-out procedure with guarding and supervision. This animation is not a collision check or production approval.' },
  @{ title='READ THE CODE. SEE THE MOTION.'; label='CNC Programming Academy · Beginner training'; code='LEARN  →  SIMULATE  →  VERIFY  →  IMPROVE'; mode='outro'; narration='Read each block, predict the tool motion, and verify the modal state. Learn with the academy simulator and lessons, then rely on the actual machine documentation and approved shop procedures.' }
)

$renderer = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;
public static class CncMovieRenderer {
 static readonly Color Bg=ColorTranslator.FromHtml("#101b23"), Panel=ColorTranslator.FromHtml("#172831"), Green=ColorTranslator.FromHtml("#25a67e"), Amber=ColorTranslator.FromHtml("#e4a443"), White=ColorTranslator.FromHtml("#edf3ef"), Muted=ColorTranslator.FromHtml("#9eb0b1"), Steel=ColorTranslator.FromHtml("#91a7a5"), Red=ColorTranslator.FromHtml("#d66a61"), Blue=ColorTranslator.FromHtml("#72a4ff");
 static Font F(float s,string f="Arial",FontStyle st=FontStyle.Regular)=>new Font(f,s,st,GraphicsUnit.Pixel);
 static void Txt(Graphics g,string s,float x,float y,float size,Color c,string face="Arial",FontStyle style=FontStyle.Regular){using(var b=new SolidBrush(c))g.DrawString(s,F(size,face,style),b,x,y);}
 static void Line(Graphics g,Color c,float w,float x1,float y1,float x2,float y2,DashStyle d=DashStyle.Solid){using(var p=new Pen(c,w)){p.DashStyle=d;p.StartCap=LineCap.Round;p.EndCap=LineCap.Round;g.DrawLine(p,x1,y1,x2,y2);}}
 static void Round(Graphics g,Rectangle r,Color c,int rad=16){using(var p=new GraphicsPath()){int d=rad*2;p.AddArc(r.X,r.Y,d,d,180,90);p.AddArc(r.Right-d,r.Y,d,d,270,90);p.AddArc(r.Right-d,r.Bottom-d,d,d,0,90);p.AddArc(r.X,r.Bottom-d,d,d,90,90);p.CloseFigure();using(var b=new SolidBrush(c))g.FillPath(b,p);}}
 static void Arrow(Graphics g,Color c,float x1,float y1,float x2,float y2,float w=5){Line(g,c,w,x1,y1,x2,y2);double a=Math.Atan2(y2-y1,x2-x1);PointF[] pts={new PointF(x2,y2),new PointF(x2-18*(float)Math.Cos(a-.5),y2-18*(float)Math.Sin(a-.5)),new PointF(x2-18*(float)Math.Cos(a+.5),y2-18*(float)Math.Sin(a+.5))};using(var b=new SolidBrush(c))g.FillPolygon(b,pts);}
 static void Machine(Graphics g,float x,float y,float w,float h){using(var p=new Pen(ColorTranslator.FromHtml("#54716e"),4))g.DrawRectangle(p,x,y,w,h);Round(g,new Rectangle((int)x+20,(int)y+20,(int)w-40,(int)h-40),ColorTranslator.FromHtml("#1c3238"),8);Line(g,Steel,4,x+w*.12f,y+h*.77f,x+w*.88f,y+h*.77f);Round(g,new Rectangle((int)(x+w*.22),(int)(y+h*.68),(int)(w*.56),(int)(h*.12)),ColorTranslator.FromHtml("#879d98"),8);}
 static void Tool(Graphics g,float x,float y,float scale=1){using(var b=new SolidBrush(Amber)){PointF[] p={new PointF(x-17*scale,y-6*scale),new PointF(x+17*scale,y-6*scale),new PointF(x,y+22*scale)};g.FillPolygon(b,p);}using(var b=new SolidBrush(Steel))g.FillRectangle(b,x-12*scale,y-78*scale,24*scale,72*scale);}
 static void Code(Graphics g,string code){Round(g,new Rectangle(100,670,750,165),Panel,14);Txt(g,"PROGRAM BLOCK",132,690,20,Muted,"Consolas",FontStyle.Bold);string[] ls=code.Split('\n');for(int i=0;i<ls.Length;i++)Txt(g,ls[i],132,726+i*42,27,ColorTranslator.FromHtml("#d8eadf"),"Consolas");}
 static void MachineBase(Graphics g){Machine(g,930,255,840,555);}
 static void Draw(Graphics g,string title,string label,string code,string mode,string caption,float progress){g.SmoothingMode=SmoothingMode.AntiAlias;g.TextRenderingHint=TextRenderingHint.ClearTypeGridFit;g.Clear(Bg);
   using(var b=new SolidBrush(Color.FromArgb(16,37,47)))g.FillEllipse(b,1180,-310,950,790);
   Txt(g,"CNC PROGRAMMING ACADEMY",100,60,20,Green,"Consolas",FontStyle.Bold);Txt(g,title,100,112,51,White,"Arial",FontStyle.Bold);Txt(g,label,104,184,26,Muted);
   Code(g,code);MachineBase(g);float t=Math.Max(0,Math.Min(1,progress));
   if(mode=="intro"||mode=="outro") {Arrow(g,Green,1120,635,1450,635,7);Tool(g,1120+330*t,450,1.35f);Txt(g,"PROGRAM",1060,315,23,Green,"Consolas",FontStyle.Bold);Txt(g,"CONTROL",1325,315,23,Amber,"Consolas",FontStyle.Bold);Txt(g,"MACHINE",1570,315,23,White,"Consolas",FontStyle.Bold);}
   else if(mode=="axes"||mode=="modes") {float ox=1330,oy=635;Arrow(g,Red,ox,oy,ox+245,oy,6);Arrow(g,Green,ox,oy,ox,oy-210,6);Arrow(g,Blue,ox,oy,ox-130,oy+110,6);Txt(g,"X",1590,612,25,Red,"Consolas",FontStyle.Bold);Txt(g,"Z",1300,390,25,Green,"Consolas",FontStyle.Bold);Txt(g,"Y",1170,742,25,Blue,"Consolas",FontStyle.Bold);Round(g,new Rectangle((int)(ox-9),(int)(oy-9),18,18),Amber,9);Txt(g,"WORK ZERO",ox-52,oy+28,18,White,"Consolas",FontStyle.Bold);if(mode=="modes"){Line(g,Amber,4,ox,oy-65,ox+140,oy-65,DashStyle.Dash);Round(g,new Rectangle((int)(ox+140-8),(int)(oy-73),16,16),Amber,8);Txt(g,t<.5f?"G90 · ABSOLUTE":"G91 · INCREMENTAL",1120,370,24,White,"Consolas",FontStyle.Bold);}}
   else if(mode=="rapid"||mode=="linear") {float sx=1080,sy=520,ex=1640,ey=520;Line(g,Amber,5,sx,sy,ex,ey,DashStyle.Dash);float q=mode=="rapid"?t:t*.55f;Tool(g,sx+(ex-sx)*q,sy-90,1.05f);if(mode=="linear"){float u=Math.Max(0,(t-.25f)/.75f);Line(g,Green,8,sx,sy+75,sx+(ex-sx)*u,sy+75);Tool(g,sx+(ex-sx)*u,sy-5,1.05f);Txt(g,"RAPID · CLEARANCE",1115,372,22,Amber,"Consolas",FontStyle.Bold);Txt(g,"FEED · CUT",1410,680,22,Green,"Consolas",FontStyle.Bold);}else Txt(g,"CHECK FIXTURE CLEARANCE",1115,680,22,Amber,"Consolas",FontStyle.Bold);}
   else if(mode=="arc") {float cx=1370,cy=535,rx=235,ry=160;using(var p=new Pen(Color.FromArgb(65,Green),8))g.DrawEllipse(p,cx-rx,cy-ry,rx*2,ry*2);int sweep=(int)(300*t);using(var p=new Pen(Green,9)){p.StartCap=LineCap.Round;p.EndCap=LineCap.Round;g.DrawArc(p,cx-rx,cy-ry,rx*2,ry*2,210,sweep);}float a=(float)((210+sweep)*Math.PI/180);Tool(g,cx+rx*(float)Math.Cos(a),cy+ry*(float)Math.Sin(a)-80,.8f);Txt(g,"G02  ↻",1075,380,25,Amber,"Consolas",FontStyle.Bold);Txt(g,"G03  ↺",1075,425,25,Green,"Consolas",FontStyle.Bold);Txt(g,"ACTIVE PLANE: G17 · XY",1120,720,21,White,"Consolas",FontStyle.Bold);}
   else if(mode=="mcodes") {float cx=1350,cy=530;using(var p=new Pen(Steel,10))g.DrawEllipse(p,cx-90,cy-90,180,180);double a=t*2*Math.PI*4;Arrow(g,Green,cx,cy,cx+75*(float)Math.Cos(a),cy+75*(float)Math.Sin(a),6);Tool(g,1570,490,1.1f);for(int i=0;i<4;i++){float xx=1480+i*55;Line(g,Blue,4,xx,620,xx-18,660);Line(g,Blue,4,xx-18,660,xx+3,680);}Txt(g,"SPINDLE",1240,680,20,White,"Consolas",FontStyle.Bold);Txt(g,"COOLANT",1480,720,20,Blue,"Consolas",FontStyle.Bold);}
   else if(mode=="process") {Line(g,Steel,30,1080,535,1670,535);Line(g,ColorTranslator.FromHtml("#b4c6c0"),24,1080,515,1670,515);float tx=1085+450*t;Tool(g,tx,475,.9f);Line(g,Amber,5,tx,540,tx,620);Txt(g,"LATHE · WORKPIECE ROTATES",1020,330,20,White,"Consolas",FontStyle.Bold);Txt(g,"MILL · CUTTER ROTATES",1320,720,20,Green,"Consolas",FontStyle.Bold);}
   else if(mode=="quality") {Round(g,new Rectangle(1040,380,630,300),Color.FromArgb(30,Green),14);Line(g,Muted,2,1110,620,1600,620);Line(g,Muted,2,1110,440,1110,620);Line(g,Amber,2,1110,530,1600,530,DashStyle.Dash);PointF[] pts=new PointF[9];for(int i=0;i<9;i++){pts[i]=new PointF(1135+i*55,550-(float)Math.Sin(i*.7+t*2)*33-(i*2));}using(var p=new Pen(Green,5))g.DrawCurve(p,pts);foreach(var q in pts)Round(g,new Rectangle((int)q.X-6,(int)q.Y-6,12,12),Green,6);Txt(g,"TARGET",1610,512,18,Amber,"Consolas",FontStyle.Bold);Txt(g,"TIME-ORDERED MEASUREMENTS",1120,640,18,White,"Consolas",FontStyle.Bold);}
   else if(mode=="safety") {Round(g,new Rectangle(1120,385,500,265),Color.FromArgb(32,Green),22);using(var p=new Pen(Green,12))g.DrawEllipse(p,1250,405,150,150);Txt(g,"✓",1283,417,90,Green,"Arial",FontStyle.Bold);Txt(g,"GUARDING",1440,420,25,White,"Consolas",FontStyle.Bold);Txt(g,"OFFSETS",1440,470,25,White,"Consolas",FontStyle.Bold);Txt(g,"CLEARANCE",1440,520,25,White,"Consolas",FontStyle.Bold);Txt(g,"APPROVED PROVE-OUT",1210,590,22,Amber,"Consolas",FontStyle.Bold);}
   // Caption band is deliberately fixed and highly legible for burned-in, synchronized subtitles.
   Round(g,new Rectangle(92,882,1736,116),Color.FromArgb(236,9,20,26),13);using(var fmt=new StringFormat()){fmt.Alignment=StringAlignment.Center;fmt.LineAlignment=StringAlignment.Center;fmt.Trimming=StringTrimming.Word;fmt.FormatFlags=0;using(var b=new SolidBrush(White))g.DrawString(caption,F(25,"Arial",FontStyle.Bold),b,new RectangleF(135,894,1650,91),fmt);}
   using(var b=new SolidBrush(Color.FromArgb(65,255,255,255)))g.FillRectangle(b,100,1040,1720,5);using(var b=new SolidBrush(Green))g.FillRectangle(b,100,1040,1720*Math.Max(.01f,Math.Min(1,progress)),5);
 }
 public static void Render(string path,string title,string label,string code,string mode,string caption,float progress){using(var bm=new Bitmap(1920,1080)){using(var g=Graphics.FromImage(bm))Draw(g,title,label,code,mode,caption,progress);bm.Save(path,ImageFormat.Png);}}
}
'@
$drawingDir = Split-Path ([System.Drawing.Bitmap].Assembly.Location)
Add-Type -TypeDefinition $renderer -ReferencedAssemblies @([System.Drawing.Bitmap].Assembly.Location,[System.Drawing.Color].Assembly.Location,(Join-Path $drawingDir 'System.Private.Windows.GdiPlus.dll'),(Join-Path $drawingDir 'System.Private.Windows.Core.dll')) -Language CSharp

$voice = [System.Speech.Synthesis.SpeechSynthesizer]::new()
$voice.Rate = -1
$voice.Volume = 100
$installed = $voice.GetInstalledVoices() | Where-Object { $_.VoiceInfo.Name -match 'Zira|Aria|Jenny' } | Select-Object -First 1
if ($installed) { $voice.SelectVoice($installed.VoiceInfo.Name) }

$segmentFiles = [System.Collections.Generic.List[string]]::new()
$index = 0
foreach ($scene in $scenes) {
  $index++
  $sceneDir = Join-Path $temp ('scene-{0:D2}' -f $index)
  New-Item -ItemType Directory -Force -Path $sceneDir | Out-Null
  $segment = Join-Path $sceneDir 'segment.mp4'
  if (Test-Path $segment) {
    $segmentFiles.Add($segment)
    Write-Host ("Reusing scene {0}/{1}: {2}" -f $index,$scenes.Count,$scene.title)
    continue
  }
  $wav = Join-Path $sceneDir 'voice.wav'
  $voice.SetOutputToWaveFile($wav)
  $voice.Speak($scene.narration)
  $voice.SetOutputToNull()
  $durationText = & $ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $wav
  $duration = [double]::Parse(($durationText | Select-Object -First 1), [Globalization.CultureInfo]::InvariantCulture)
  $videoDuration = $duration + 1.2
  $frameCount = [int][Math]::Ceiling($videoDuration * $FramesPerSecond)
  for ($frame=0; $frame -lt $frameCount; $frame++) {
    $fraction = [Math]::Min(1, $frame / [Math]::Max(1,$frameCount - 1))
    $framePath = Join-Path $sceneDir ('frame-{0:D5}.png' -f $frame)
    $displayCode = $scene.code.Replace('\n',"`n")
    [CncMovieRenderer]::Render($framePath,$scene.title,$scene.label,$displayCode,$scene.mode,$scene.narration,$fraction)
  }
  & $ffmpeg -hide_banner -loglevel error -y -framerate $FramesPerSecond -i (Join-Path $sceneDir 'frame-%05d.png') -i $wav -vf 'scale=1920:1080:flags=lanczos,format=yuv420p' -c:v libx264 -preset medium -crf 19 -r $FramesPerSecond -c:a aac -b:a 160k -af 'apad=pad_dur=1.2' -shortest -movflags +faststart $segment
  if ($LASTEXITCODE -ne 0) { throw "FFmpeg failed while encoding scene $index" }
  $segmentFiles.Add($segment)
  Write-Host ("Rendered scene {0}/{1}: {2}" -f $index,$scenes.Count,$scene.title)
}
$voice.Dispose()

$listPath = Join-Path $temp 'segments.txt'
$listContent = ($segmentFiles | ForEach-Object { "file '$($_.Replace("'","'\''"))'" }) -join "`n"
[IO.File]::WriteAllText($listPath,$listContent,[Text.Encoding]::ASCII)
$output = Join-Path $OutputDirectory 'CNC-Programming-Essentials.mp4'
& $ffmpeg -hide_banner -loglevel error -y -f concat -safe 0 -i $listPath -c copy -movflags +faststart $output
if ($LASTEXITCODE -ne 0) { throw 'FFmpeg failed while assembling the final movie' }

$transcript = Join-Path $OutputDirectory 'CNC-Programming-Essentials-transcript.txt'
$lines = @('CNC Programming Essentials — narration transcript','', 'Educational training only. Follow the actual machine manual, setup documentation, and approved shop procedures.', '')
foreach ($scene in $scenes) { $lines += $scene.title; $lines += $scene.narration; $lines += '' }
[IO.File]::WriteAllLines($transcript,$lines,[Text.Encoding]::UTF8)
$resolvedOutput = [IO.Path]::GetFullPath($OutputDirectory)
$resolvedTemp = [IO.Path]::GetFullPath($temp)
if (-not $resolvedTemp.StartsWith($resolvedOutput + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) {
  throw "Refusing to remove render intermediates outside the output directory: $resolvedTemp"
}
Remove-Item -LiteralPath $resolvedTemp -Recurse -Force
Write-Host "Movie: $output"
Write-Host "Transcript: $transcript"
