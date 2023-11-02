extends Node3D

#添加变量,方便调试
var 鼠标输入           #同于检测是否在控制鼠标
var 鼠标输入旋转        #控制鼠标左右旋转
var 鼠标输入倾斜        #控制鼠标上下旋转
var 鼠标灵敏度:float=0.25    #控制鼠标灵敏度我们默认设置为0.25

var 欧拉_旋转:Vector3      #用于改变相机的旋转模式
@export var 限制_上:=deg_to_rad(-60.0)   #限制相机左右视角角度
@export var 限制_下:=deg_to_rad(60.0)    #限制相机上下视角角度


# Called when the node enters the scene tree for the first time.
func _ready():
	#开局把摄像机隐藏 方便控制  这段函数是场景运行时将鼠标隐藏 并锁定在屏幕中间 用到MOUSE_MODE_CONFINED这个常量
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  #注意这里换了
	pass # Replace with function body.


func  _physics_process(delta):
	#在物理虚函数写下代码 让相机旋转
	#将旋转模式改为欧拉旋转
	欧拉_旋转.x+=鼠标输入倾斜*delta       #将上下向量赋值给欧拉旋转x轴向量
	欧拉_旋转.x=clamp(欧拉_旋转.x,限制_上,限制_下)  #这段限制相机上下旋转镜头
	欧拉_旋转.y+=鼠标输入旋转*delta         #这段将作业向量赋予欧拉Y轴
	
	#通过矩阵向量控制相机的旋转      #到这一步 相机的视角旋转就可以实现了
	transform.basis=Basis.from_euler(欧拉_旋转)
	
	#记得把变量归零 要不然视口会一直在动
	鼠标输入倾斜=0.0
	鼠标输入旋转=0.0
	
	pass
	
	
	
	
	
	
	
	
#添加输入控制的虚函数 这段函数主要用来处理玩家各种输入操作的
func _input(event):
	#将鼠标状态传递给 鼠标输入 这个变量
	#这段代码为 鼠标状态 等于鼠标在移动 与鼠标模式为隐藏状态
	鼠标输入=event is InputEventMouseMotion and Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED
	
	#下面获得鼠标变量,方便控制视角
	#如果 鼠标输入为真
	#执行以下代码
	if 鼠标输入:        #这段代码会将鼠标移动位置转换为所需变量,方便控制
		鼠标输入旋转=-event.relative.x*鼠标灵敏度  #x轴旋转需要的变量
		鼠标输入倾斜=-event.relative.y*鼠标灵敏度  #y轴旋转需要的变量











