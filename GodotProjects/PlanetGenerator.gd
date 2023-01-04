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

	
	for x in range(0,512):
		colorArray.append([])
		for y in range(0,512):
			var f =0.0
			f=noise.get_noise_2d(x,y)
			
			
			if f <0:
				pass
			
			colorArray[x].append(Color(f,f,f,1))
			
		
	

func BetterGroundGenerator():
	pass

func GetNoiseTexture():
	var noise = OpenSimplexNoise.new()
	
	noise.seed=4
	noise.octaves=4
	noise.period =64.0
	noise.lacunarity=2.0
	noise.persistence=0.5
	return noise
	
class innerClass:
	var color =[]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
