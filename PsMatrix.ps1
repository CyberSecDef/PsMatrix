Begin{
    $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
	[console]::BackgroundColor="Black";
    [console]::cursorVisible=$false
	clear
    Class Sprite{
        static $characters	= [System.Collections.ArrayList]($((@(33..47),@(58..64),@(91..96),@(123..126))) | %{$_}|?{$_ -ne $null}|sort{get-random}|%{[char]($_)})
		
		$X              	= (get-random -Minimum 1 -maximum ([console]::windowWidth) )
        $Y              	= ( [math]::floor( ( get-random -Minimum 1 -maximum ( [console]::windowHeight * .1 ))))
        $Length         	= (get-random -minimum 65 -maximum ([console]::WindowHeight * 3))
        $Iterations     	= 1
        $active         	= $true
		$moving				= $false
        
		Sprite(){
		
        }
		static [char] getChar(){
			return ([Sprite]::characters[(get-random -minimum 0 -maximum ([Sprite]::characters.count))] )
		}		
		drawFlash($bg){
			for($g = 255; $g -ge 5; $g = $g - 25){
				for($i = 0; $i -le $this.iterations; $i++){
					if(  ($this.Y + $i) -lt ([console]::WindowHeight - 4)){
						[console]::SetCursorPosition($this.X, ($this.Y + $i) )
						write-host -noNewLine "$([char]27)[38;2;0;$($g);0m$([Sprite]::getChar())$([char]27)[" 
					}
				}
			}
			
			if($bg){
				for($xx = ($this.x - 2); $xx -lt ($this.x + 2); $xx++){
					if($xx -ge 0 -and $xx -le ([console]::windowWidth) ){
						for($yy = $this.y ; $yy -lt [console]::windowHeight - 4; $yy++){
							$gCounter = get-random -minimum 32 -maximum 48
							[console]::SetCursorPosition($xx, ($yy) )
							write-host -noNewLine "$([char]27)[38;2;24;$($gCounter);25m$([Sprite]::getChar())$([char]27)[" 
						}
					}
				}
			}
					
		}
        drawTail(){
            if($this.active){
				for($i = 0; $i -le $this.iterations; $i++){
                    if(  ($this.Y + $i) -lt ([console]::WindowHeight - 4)){
                        $gCounter = [math]::floor( 255 / $this.iterations)
						[console]::SetCursorPosition($this.X, ($this.Y + $i) )
						write-host -noNewLine "$([char]27)[38;2;24;$(32 + $gCounter * $i);25m$([Sprite]::getChar())$([char]27)[" 
                        
                    }
                }
				if( ($this.Y + $this.iterations) -ge ([console]::windowHeight + 25)){
					$this.drawFlash($true);
					$this.active = $false
				}
            }
        }
        drawHead(){
            if($this.active){
                if(  ($this.Y + $this.iterations) -lt ([console]::WindowHeight - 4)){
                    [console]::SetCursorPosition($this.X, ($this.Y + $this.iterations ) )
					if($this.moving){
						write-host -noNewLine "$([char]27)[38;2;255;255;255m$([Sprite]::getChar())$([char]27)[" 
					}else{
						write-host -noNewLine "$([char]27)[38;2;0;96;0m$([Sprite]::getChar())$([char]27)[" 
					}
                }
            }
        }
    }
    
    Class Matrix{
        $sprites=@()
		$spriteGen = .20
		$moveChance = 500
		
        Matrix(){
			$this.drawBackground();
        }
		drawBackground(){
			for($x = 0; $x -lt [console]::windowWidth; $x++){
				for($y = 0; $y -lt [console]::windowHeight - 4; $y++){					
					$gCounter = get-random -minimum 32 -maximum 48
					[console]::SetCursorPosition($X, ($Y) )
					write-host -noNewLine "$([char]27)[38;2;24;$($gCounter);25m$([Sprite]::getChar())$([char]27)[" 
				}
			}
		}
		newSprite(){
			$newSprite = [Sprite]::new()
			while(( $this.sprites | ? { $_.X -eq $newSprite.X -or ($_.X - 1 )-eq $newSprite.X -or ($_.X + 1) -eq $newSprite.X }).count -ge 1  ){
				$newSprite.X = (get-random -Minimum 1 -maximum ([console]::windowWidth) )
			}
			
			$this.sprites += ( $newSprite )
		}
		remSprite(){
			$this.sprites = ($this.sprites | ? { $_.active } | sort { $_.X})
			if($this.sprites.count -eq 0){
				$this.sprites = @()
				$this.sprites += [Sprite]::new();
			}
		}
		toggleMovement(){
			if( ($this.sprites | ? { $_.moving }).count -lt ([console]::windowWidth*$this.spriteGen)){
				foreach($sprite in ($this.sprites | ? { !$_.moving })){
					if( (get-random -minimum 1 -maximum 1000) -lt $this.moveChance){
						$sprite.moving = $true;
					}
				}
			}
			$this.sprites | ? { $_.moving } | %{
				if( (get-random -minimum 1 -maximum 1000) -gt $this.moveChance){
					$_.moving = $false;
				}
			}
		}
		invokeMovement(){
			foreach($sprite in ($this.sprites | ? { $_.active -and $_.moving } | sort -descending { $_.iterations} ) ){
					$sprite.iterations++
					$sprite.Y++
					$sprite.drawTail();
					$sprite.drawHead();
			}
		}
		setLegend($index){
			[console]::SetCursorPosition(0, 0 )
			write-host -noNewLine "$([char]27)[38;2;255;255;255mIndex:$($index)    $([char]27)["
			
			[console]::SetCursorPosition(0, 1 )
			write-host -noNewLine "$([char]27)[38;2;255;255;255mActive:$(($this.sprites | ? { $_.active} ).count)    $([char]27)["
			
			[console]::SetCursorPosition(0, 2 )
			write-host -noNewLine "$([char]27)[38;2;255;255;255mMoving:$(($this.sprites | ? { $_.active -and $_.moving} ).count)    $([char]27)["

			[console]::SetCursorPosition(0, 3 )
			write-host -noNewLine "$([char]27)[38;2;255;255;255mSprites:$( [math]::floor( [console]::windowWidth * $this.spriteGen) )    $([char]27)["
		
			[console]::SetCursorPosition(0, 4 )
			write-host -noNewLine "$([char]27)[38;2;255;255;255mMovement:$( [math]::round($this.moveChance / 1000,3) )    $([char]27)["
			
			while([console]::keyAvailable){
				$key = [Console]::readKey($true)
				# [console]::SetCursorPosition(0, 5 )
				# write-host -noNewLine "$([char]27)[38;2;255;255;255mSprite:$(( $key.key ))      $([char]27)["
				
				switch($key.key){
					"OemPeriod"	{$this.spriteGen += .01}
					"OemComma"	{$this.spriteGen -= .01}
					"OemPlus"	{$this.moveChance += 25}
					"OemMinus"	{$this.moveChance -= 25}
					"Spacebar"	{$this.drawBackground()}
					"K"			{$this.sprites | sort { $_.iterations } | % { $_.active = $false; $_.drawFlash($false)}; $this.sprites[0].active = $true;}
					"H"			{$this.spriteGen = 0; $this.moveChance = 0;}
					"Q"			{exit;}
				}
				
				$key = $null
			}
		}
        loop(){
            $index = 0
            while($true){               
                $index++
				$this.setLegend($index);
                if( ($this.sprites | ? { $_.active}).count -lt ([console]::windowWidth * $this.spriteGen)){
					$this.newSprite();					
                }		
				if($this.sprites.count -gt 2 ){
					$this.remSprite()
				}
				$this.toggleMovement()
				$this.invokeMovement()
            }
        }
    }
}
Process{
    $matrix = [Matrix]::new()
    $matrix.loop()
}
End{

}
