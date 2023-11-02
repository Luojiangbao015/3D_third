extends CharacterBody3D
#我们开始写玩家的脚本
#首先定义一些我们需要用到的变量

#获取所需要的节点
@onready var 相机根:=$"相机根"
@onready var 玩家:MeshInstance3D=$"玩家身体"

@onready var 旋转向量:=Vector3.FORWARD



#定义基础变量
@export var 玩家基础移动:=10
@export var 玩家加速移动:=20
@export var 玩家旋转速度:=12.0

#变量都定义完了


#定义跳跃高度的变量
var 跳跃=4.5

#先给角色添加重力
#定义一个变量获取获取默认重力   这是系统默认的重力 是全局变量
var 重力=ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#添加一个物理虚函数
func _physics_process(delta):
	
	#添加掉落条件 如果不与地板碰撞,则往下掉
	# 需要用到 IS_ON_FLOOR这个函数
	if not is_on_floor():
		velocity.y-=重力*delta
		
	#添加跳跃条件
	if Input.is_action_just_pressed("跳跃")and is_on_floor():
		velocity.y=跳跃



#在一下代码中控制角色的移动和旋转 我们先自定义两个函数 
#定义一个变量获取相机矩阵就算返回的输入向量
	var 输入向量=相机_返回()
	
	#通过调节把输入向量规格化后赋予旋转向量
	if 输入向量.length()>0.2:
		旋转向量=输入向量.normalized()
	
	#将获得的输入向量通过参数传给自定义的函数计算
	玩家_旋转(旋转向量,delta)
	
	
	#下边控制角色移动
	#先将y轴分离出来,避免影响重力
	var 向量分离_y=velocity.y #记录y轴向量
	velocity.y=0.0       #将y轴归零
	
	#角色移动代码如下 这样玩家移动就可以数显了 接下来还要左旋转方向
	velocity=velocity.lerp(-输入向量*玩家基础移动,玩家加速移动*delta)

	if 输入向量.length()==0 and velocity.length()<1:
		velocity=Vector3.ZERO
		
	velocity.y=向量分离_y

	print(delta)














#要做角色移动跳跃等 需要加上这个函数,用于控制移动向量velocity的计算
	move_and_slide()
	
	#重力有了 现在我们先做相机的控制


#这个函数用于返回相机的矩阵向量 用来计算角色的移动和旋转等
func 相机_返回():
#定义一个变量 获取按键的输入向量
	var 按键向量:=Input.get_vector("左","右","上","下")
	#定义一个向量初始化为0
	var  输入向量:=Vector3.ZERO
	#计算按键向量的平方根肚子给输入向量
	输入向量.x=-按键向量.x*sqrt(1.0-按键向量.y*按键向量.y/2.0)
	输入向量.z=-按键向量.y*sqrt(1.0-按键向量.x*按键向量.x/2.0)

	#将相机的矩阵向量赋予输入向量
	输入向量=相机根.global_transform.basis*输入向量
	输入向量.y=0.0   #归零y轴
	return 输入向量     #返回向量



#创建一个自定义函数  用于计算玩家的旋转和朝向
func 玩家_旋转(向前向量:Vector3,delta:float)->void:
	#定义一个变量 获取叉积
	var 左_对称轴=Vector3.UP.cross(向前向量)
	#定义一个 变量获取
	var 基础位置:=Basis(左_对称轴,Vector3.UP,向前向量).get_rotation_quaternion()
	#定义一个变量获取觉得的矩阵向量
	var 角色矩阵:=玩家.transform.basis.get_scale()
	
	玩家.transform.basis=Basis(玩家.transform.basis.get_rotation_quaternion().slerp(基础位置,delta*玩家旋转速度)).scaled(角色矩阵)
	
	#这段下号了 可以调用了
	
	
	


