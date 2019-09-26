join_token_url=${join_token_url}
while ! curl $join_token_url
do
  sleep 5
  echo waiting for $join_token_url
done
join_token=`curl $join_token_url`
exec sh -c $join_token
