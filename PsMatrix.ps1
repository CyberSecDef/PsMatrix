Begin{
    $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
	[console]::BackgroundColor="Black";
    [console]::cursorVisible=$false
	clear
    Class Sprite{
        static $characters	= [System.Collections.ArrayList]($((@(33..47),@(58..64),@(91..96),@(123..126))) | %{$_}|?{$_ -ne $null}|sort{get-random}|%{[char]($_)})
		
		$X              	= (get-random -Minimum 1 -maximum ([console]::windowWidth) )
        $Y              	= ( [math]::floor( ( get-random -Minimum 1 -maximum ( [console]::windowHeight * .1 ))))
        $Length         	= (get-random -minimum 45 -maximum ([console]::WindowHeight * 5))
        $Iterations     	= 1
        $active         	= $true
		$moving				= $false
        
		Sprite(){
		
        }
		static [char] getChar(){
			return ([Sprite]::characters[(get-random -minimum 0 -maximum ([Sprite]::characters.count))] )
		}		
		drawFlash(){
			for($g = 255; $g -ge 5; $g = $g - 10){
				for($i = 0; $i -le $this.iterations; $i++){
					if(  ($this.Y + $i) -lt ([console]::WindowHeight - 10)){
						[console]::SetCursorPosition($this.X, ($this.Y + $i) )
						write-host -noNewLine "$([char]27)[38;2;0;$($g);0m$([Sprite]::getChar())$([char]27)[" 
					}
				}
			}
		}
        drawTail(){
            if($this.active){
                for($i = 0; $i -le $this.iterations; $i++){
                    if(  ($this.Y + $i) -lt ([console]::WindowHeight - 10)){
                        $gCounter = [math]::floor( 192 / $this.iterations)
						[console]::SetCursorPosition($this.X, ($this.Y + $i) )
						write-host -noNewLine "$([char]27)[38;2;24;$(64 + $gCounter * $i);25m$([Sprite]::getChar())$([char]27)[" 
                        
                    }
                }
				if( ($this.Y + $this.iterations) -ge ([console]::windowHeight + 25)){
					$this.drawFlash();
					$this.active = $false
				}
            }
        }
        drawHead(){
            if($this.active){
                if(  ($this.Y + $this.iterations) -lt ([console]::WindowHeight - 10)){
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
        Matrix(){
			$this.drawBackground($true);
        }
		drawBackground($full){
			switch($full){
				$true{
					for($x = 0; $x -lt [console]::windowWidth; $x++){
						for($y = 0; $y -lt [console]::windowHeight - 10; $y++){
							if( (get-random -minimum 0 -maximum 1000) -gt 500){
								$gCounter = get-random -minimum 16 -maximum 48
								[console]::SetCursorPosition($X, ($Y) )
								write-host -noNewLine "$([char]27)[38;2;24;$($gCounter);25m$([Sprite]::getChar())$([char]27)[" 
							}
						}
					}
				}
				$false{
					for($i=0; $i -lt 15; $i++){
						$gCounter = get-random -minimum 16 -maximum 48
						[console]::SetCursorPosition((get-random -minimum 0 -maximum ([console]::windowWidth)) , (get-random -minimum 0 -maximum ([console]::windowHeight - 10)) )
						write-host -noNewLine "$([char]27)[38;2;24;$($gCounter);25m$([Sprite]::getChar())$([char]27)[" 
					}
				}
			}
		}
		newSprite(){
			$newSprite = [Sprite]::new()
			while(( $this.sprites | ? { $_.X -eq $newSprite.X -or ($_.X - 1 )-eq $newSprite.X -or ($_.X + 1) -eq $newSprite.X }).count -ge 1  ){
				$newSprite.X = (get-random -Minimum 1 -maximum ([console]::windowWidth) )
			}
			$this.sprites += $newSprite
		}
		remSprite(){
			$this.sprites = ($this.sprites | ? { $_.active } | sort { $_.X})
		}
		toggleMovement(){
			if( ($this.sprites | ? { $_.moving }).count -lt 15){
				for($s = 0; $s -lt $this.sprites.count; $s++){
					if( (get-random -minimum 1 -maximum 1000) -gt 990){
						$this.sprites[$s].moving = $true;
					}
				}
			}
			$this.sprites | ? { $_.moving } | %{
				if( (get-random -minimum 1 -maximum 1000) -gt 990){
					$_.moving = $false;
				}
			}
		}
		invokeMovement(){
			foreach($sprite in ($this.sprites | ? { $_.active -and $_.moving } ) ){
				if(((get-random -minimum 1 -maximum 1000) -gt 750) ){
					$sprite.iterations++
					$sprite.Y++
					$sprite.drawTail();
					$sprite.drawHead();
				}else{
					$sprite.drawHead();
				}
			}
		}
		setLegend($index){
			[console]::SetCursorPosition(0, 0 )
			write-host -noNewLine "$([char]27)[38;2;255;255;255mIndex:$($index)$([char]27)["
			
			[console]::SetCursorPosition(0, 1 )
			write-host -noNewLine "$([char]27)[38;2;255;255;255mActive:$(($this.sprites | ? { $_.active -and $_.moving} ).count)$([char]27)["
		}
        loop(){
            $index = 0
            while($true){               
                $index++
				$this.setLegend($index);
				$this.drawBackground($false);

                if( ($this.sprites | ? { $_.active}).count -lt ([console]::windowWidth * .25)){
					$this.newSprite();					
                }		

				if($this.sprites.count -gt 1 ){
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
