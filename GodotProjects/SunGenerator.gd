extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var noiseEffect: float =1.0
var cp =load("ColorArray.gd")
var textureArray = []
var colorArray =[]
# Called when the node enters the scene tree for the first time.
func _ready():

	
	
	var noise = GetNoiseTexture()
	ClampNoiseTexture(noise)
	self.texture = setToTexture(Vector2(512,512))

	
func setToTexture(rect_size:Vector2)->ImageTexture:
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()

	dynImage.create(rect_size.x,rect_size.y,false,Image.FORMAT_RGB8)

	dynImage.lock()
	for i in range(0,512):
		
		for j in range(0,512):
			dynImage.set_pixel(i,j, colorArray[i][j])
	dynImage.unlock()
	imageTexture.create_from_image(dynImage,4)
		
	return imageTexture
	
	
func ClampNoiseTexture(noise:OpenSimplexNoise):

	var yellow = Color.yellow
	
	var red = Color.red
	var bg_color = Gradient.new()
	
	bg_color.add_point(0.0,yellow)
	bg_color.add_point(0.75,Color.red)
	bg_color.add_point(0.9,Color.black)
	bg_color.set_color(4,red)
	print(bg_color.get_point_count())
	print(bg_color.get_color(2))
	print(bg_color.interpolate(1.0))
	var c:Color
	for x in range(0,1024):
		colorArray.append([])
		for y in range(0,1024):
			var f =0.0
			f=noise.get_noise_2d(x,y)
			if(f<0):
				f*=-1
			
			if f<=0.2&& f>0:
				c=yellow
			elif f >0.2 and f < 0.5:
				c=Color.orangered
			elif f>0.5:
				c=Color.red
			else:
				c=Color.black
		
		
			colorArray[x].append(c)
			
		
	

func BetterGroundGenerator():
	pass

func GetNoiseTexture():
	var noise = OpenSimplexNoise.new()
	
	noise.seed=4
	noise.octaves=4
	noise.period =32.0
	noise.lacunarity=2.0
	noise.persistence=0.5
	
	return noise
	
class innerClass:
	var color =[]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
