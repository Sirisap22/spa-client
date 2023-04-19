<script>
	import axios from 'axios';
	import { onMount } from 'svelte'

  let newItem = '';
  let todoList = []
	const endpoint = import.meta.env.VITE_ENDPOINT || 'http://localhost:3000/todos'
	onMount(async function() {
		const response = await axios.get(endpoint)
		const data = await response.data
		todoList = data
	})
	
	async function addToList() {
		const res = await axios.post(endpoint, {
			text: newItem,
			status: false
		})
		todoList = [...todoList, { ...res.data }];
		newItem = '';
	}

	async function changeStatus(index) {
		await axios.put(`${endpoint}/${todoList[index]._id}`, {
			text: todoList[index].text,
			status: !todoList[index].status
		})
	}
	
	async function removeFromList(index) {
		await axios.delete(`${endpoint}/${todoList[index]._id}`)
		todoList.splice(index, 1)
		todoList = todoList;
  }

</script>
<div class="d-flex justify-content-center align-items-center flex-column">

<h1>System Admin Todo List</h1>
<div class="input-group mb-3 justify-content-center">
<input bind:value={newItem} type="text" placeholder="new todo item..">
<button on:click={addToList} class="btn btn-success">Add</button>
</div>

<div>
<br/>
{#each todoList as item, index}
	<input on:click={() => changeStatus(index)} bind:checked={item.status} type="checkbox">
	<!-- <input bind:checked={item.status} type="checkbox"> -->
	<span class:checked={item.status}>{item.text}</span>
	<span on:click={() => removeFromList(index)}>❌</span>
	<br/>
{/each} 
</div>
</div>


<style> 
	.checked {
        text-decoration: line-through;
    }
</style> 
