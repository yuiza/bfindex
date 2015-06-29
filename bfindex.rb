require 'digest'
#呼び出し方 & 文字列化
#Digest::MD5.haexdigest('hoge').to_s

#bit size 32bit(8byte)
SIZE = 32
#初期化
BFINDEX = Array.new(SIZE){0}
# salts
S = [13, 229, 727, 859, 193]

# Hash Function [MD5(key + Salt) % SIZE]
def hash(obj)
	h = Array.new(5){0};

	S.length.times do |i|
		tmp = 0
		md5 = Digest::MD5.hexdigest(obj.to_s + S[i].to_s).unpack("B*")

		md5.to_s.each_char.with_index { |c, i|
			if c.to_i == 1 then
			 	tmp+=1
			end
		}
		h[i] = (tmp + S[i]) % SIZE
	end

	return h
end

# Bloom Filter

# BFindex Register Function
def reg(obj)
	keys = hash(obj).flatten
	
	keys.each do |key|
		BFINDEX[key] = 1
	end
end

# BFindex Search Fucntion
def search(obj)
	puts obj
	key = hash(obj).flatten
	flags = 0
	flag = 0

	tmp = Array.new(SIZE){0}

	puts key

	key.each do |k|
		tmp[k] = 1
	end

	print("index:	", BFINDEX.join(""), "\nKEYS:	", tmp.join(""), "\n")

	key.each do |i|
		print("i: ", i, " -> ",BFINDEX[i] , "|",tmp[i])
		if BFINDEX[i] != 0 then
			flag = flag + 1
		end
	end

	if flag == 5
		print("\npositive\n\n")
	else
		print("\nnegative\n\n")
	end
end



##
# Main
##
# ネコのデータ引用元
# http://www.ax.sakura.ne.jp/~hy4477/link/zukan/zukan.htm
words = ["ユキヒョウ", "ロシアンブルー", "スマトラトラ", "チーター", "ノラネコ",
		 "ツシマヤマネコ", "アメリカンショートヘア", "メインクーン", "スコティッシュフォールド", "サーバル"]
	#"アビシニアン", "アフリカライオン", "アムールトラ", "アムールヤマネコ", "アメリカンカール", "アメリカンショートヘア",
	#"インドライオン", "ウンピョウ", "エジプシャンマウ", "オオヤマネコ", "オシキャット", "オセロット", "オリエンタルショートヘア"
	# "カラカル", "キムリック", "サーバル", "シベリアオオヤマネコ", "ジャガー", "シャルとリュー", "スコティッシュフォールド", "スマトラトラ",
	# "チーター", "ツシマヤマネコ", "ノラネコ", "バーマン", "ピューマ", "ペルシャ", "ベンガルヤマネコ", "ホワイトタイガー", "マヌルネコ",
	# "マンチカン", "メインクーン", "ユキヒョウ", "ラガマフィン", "ロシアンブルー"]
# false Positiveは5匹登録状態で「ピューマ」で起こる

words.each do |cat|
	print(cat, ", ")
	reg(cat)
end

puts

print(BFINDEX.join(""), "\n")

begin

while true
	puts "ネコ科辞書（10匹）"
	puts "add : a hoge｜search: s hoge｜終了(exit): e"
	print("コマンド")
	num = gets.chomp

	case num
	when /a /
		puts "add..."
		x = num.split('add ')
		reg(x)
	when /s /
		puts "search"
		x = num.split('search ')
		search(x)
	when 'e'
		break
	end
end

rescue Interrupt
	exit()
end